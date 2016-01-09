

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

formatHtml = (o, lv=0) ->
  t = ''
  if o.name
    t += '<span class="starttag">'+H(o.name)
    t += ' <span class="attribnam">'+H(k[1..])+'</span>="<span class="attribval">'+H(v)+'</span>"' for k,v of o when k[0]=='_'
    t += '</span>'
  if o.text
    t += H(o.text)
  if ch = o.children
    ch--
    t += formatHtml(o[i], lv+1) for i in [0..ch]
  t += '<span class="endtag">'+H(o.name)+'</span>' if o.name
  t

rx = (e) ->
  $("#out").html H(e.data.src)+'\n'+formatHtml(e.data.html)
  log 'page', dump(e.data)

$ ->
  window.addEventListener "message", rx, false
  $('.launch').click clickLaunch

