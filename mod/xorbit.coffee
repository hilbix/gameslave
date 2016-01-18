# Module for xorbit.de
#
# Mondschusswahrscheinlichkeit:
#
# RS := Rohstoffspeed vom Uni
# MW := 20 = Mond Maximalwahrscheinlichkeit
# F  := 0.3 = Faktor
# LJ := 4000 = Resourcen Leichter Jäger (Met + Krist)
#
# Units(X) := MW * 100000 * RS / X  / F
# Units(LJ) = MW * 100000 * RS / LJ / F


class XOrbit extends GameSlaveModule
  constructor: ->
    super 'xorbit'

#    @game 'uni1', 'http://uni1.xorbit.de/frames.php'
#    @game 'uni2', 'http://uni2.xorbit.de/frames.php'
#    @game 'uni3', 'http://uni3.xorbit.de/frames.php'

    @route "frames.php", -> null
    @route "leftmenu.php", -> null
    @route "buildings.php", @buildings
    @route "galaxy.php?mode=0", @galaxy
    @route "fleet.php", @fleet
    @route "overview.php", @overview
#    @route "", (match) -> return "unknown: "+match.s

  routing: (match) ->
   @uni = match[1]
   match[2]

  pattern: ///
    http://uni([0-9]+)\.xorbit\.de/
    ///i

  buildings: (match) ->
    return "building " + dump(match)

  galaxy: (match) ->
    return "galaxy"

  fleet: (match) ->
    return "galaxy"

  overview: (match) ->
    return "overview"

new XOrbit()
