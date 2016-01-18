
pressedButton = undefined
childWindow = undefined

clickLaunch = ->
  # remove previous pressed button and remember new one
# # if NULL, jQuery wraps this with a dummy object
  $(pressedButton).removeClass('pressed')
  pressedButton = @

  # show current button pressed
  b = $(@).addClass('pressed')

  # Do we have a child open already?
  childWindow = b.data('open child')
  childWindow = undefined if childWindow?.closed  # a bit redundant, see below
  return if childWindow

  # no, build one
  u = b.html()
  c = childWindow = window.open u, u
  return unless c   # failed, do nothing

  # Check until the childWindow is closed
  # XXX TODO XXX
  # Keep it busy checking until I need to find a better way to do this.
  b.data('open child', c).addClass('loaded')
  r = setInterval ->
    return unless c.closed
    clearInterval r
    b.data('open child', 0).removeClass('loaded pressed');
    childWindow = undefined if c == childWindow
    return
  , 250
  return

H = htmlentities

formatHtml = (oo) ->
  t = []
  f = (o) ->
    if o.name
      t.push '<span class="starttag">'
      t.push H(o.name)
    if o.attr
      for k in o.attr
        t.push ' <span class="attribnam">'
        t.push H(k[0])
        t.push '</span>="<span class="attribval">'
        t.push H(k[1])
        t.push '</span>"'
    t.push '</span>' if o.name
    t.push H(o.text) if o.text
    if o.sub
      f(u) for u in o.sub
    if o.name
      t.push '<span class="endtag">'
      t.push H(o.name)
      t.push '</span>'
  f(oo)
  t.join('')

haveMatch = (pattern, s) ->
  if pattern instanceof RegExp
    m = pattern.exec(s)
    return null if m is null
    o = { s:s, match:m[0], parts:m[1..] }
    i = s.indexOf(m[0])
    o.start = if i>0 then s[0..(i-1)] else ""
    o.end = s[(i + m[0].length) ..]
    return o
  return { s:s, match:pattern, start:'', end:s[pattern.length ..] } if s.startsWith(pattern)
  return null

out = (s...) ->
  if s.length>1 or s[0] not instanceof String
    s = dump(s...)
  else
    s = s[0]
  $("#out").html H s

diag = (s) -> $("#diag").html s

cnt = 0
rx = (e) ->
  cnt++
  out cnt + ' ' + e.data.src
  diag ''
  pg = e.data.src
  err = "no module found to handle this"
  for mod in gameSlaves
    log 'P', mod.pattern
    if m = haveMatch(mod.pattern, pg)
      try
        err = mod.router m
        return if !err
      catch x
        err = "module "+mod.name+" error: "+x
      break
  out cnt + ' ' + e.data.src + ': ' + err
  diag formatHtml(e.data.html)
#  log 'page', dump(e.data, 7)

gameSlaves = []
gameSlaveRegister = (module) ->
  gameSlaves.push module if module not in gameSlaves

class @GameSlaveModule
  constructor: (@name) ->
    gameSlaveRegister @

  pattern: ""
  routes: []

  routing: (match) -> log "GameSlaveModule", @name, "match", match
  route: (r, fn) -> @routes.push { route:r, fn:fn }

  router: (match) ->
    log match
    for r in @routes
      if m = haveMatch(r.route, match.end)
        return r.fn m
    return "no match for: '"+match.end+"'"

$ ->
  window.addEventListener "message", rx, false
  $('.launch').click clickLaunch

