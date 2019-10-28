;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                          FFCA with Ungulates                                 ;;
;;                                                                              ;;
;;  Code licenced by James D.A. Millington (http://www.landscapemodelling.net)  ;;
;;  under a Creative Commons Attribution-Noncommercial-Share Alike 3.0          ;;
;;  Unported License (see http://creativecommons.org/licenses/by-nc-sa/3.0/)    ;;
;;                                                                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

globals [
  burned-trees-total   ;; list of fire areas
  burned-trees-fire    ;; fire area of this fire
  max-area             ;; area (number of trees burned) in the largest fire

  max-total-area       ;;total are in the world (height * width)
  plot-interval        ;; plotting

  last_spark           ;;keeps track of time since last spark was dropped
  count-fires          ;;number of sparks that caused an ignition
  count-sparks         ;;number of sparks dropped
]

breed [ungulates ungulate]
ungulates-own [energy]

to setup

  __clear-all-and-reset-ticks
  set-default-shape turtles "square"
  ask patches [ set pcolor brown ]

  let tree-count (count patches) * (initial-trees / 100)   ;calculate how many 'trees' (i.e. green patches) we want at start
  ask n-of tree-count patches [ set pcolor green ]         ;ask random number of that many trees to turn green

  set last_spark 0   ;reset

  set burned-trees-total[]
  set max-total-area (world-width * world-height)
  set plot-interval round (max-total-area / 50)

  ;create the initial ungulates
  repeat initial-ungulates     ;repeat the following commands the number of times specified by initial-ungulates slider
  [
    ask one-of patches
    [
      sprout-ungulates 1
      [
        set energy 100
        set color yellow
      ]
    ]
  ]

end

to go

  set burned-trees-fire 0
  ask patches with [ pcolor = red ] [ set pcolor brown ]         ;burned trees from last tick
  ask one-of patches with [pcolor != green] [set pcolor green]   ;drop a tree

  if (last_spark * spark_freq) > 1   ;if it has been long enough since the last spark was dropped
  [
    drop_spark
    plotting
  ]

  set last_spark last_spark + 1    ;increase time counter
  if burned-trees-fire != 0 [set burned-trees-total lput burned-trees-fire burned-trees-total]
  if not empty? burned-trees-total [ set max-area max burned-trees-total ]
  set burned-trees-fire 0

  ask ungulates
  [
    move
    if(energy <= 0) [ die ]
    reproduce
  ]

  tick

end



;;///FIRE PROCEDURES///
to drop_spark

  set count-sparks count-sparks + 1   ;increase spark counter
  ask one-of patches                  ;ask a random one of the patches
  [
    if pcolor = green                 ;if there is a tree on this patch
    [
      ignite                           ;ignite the tree on this patch
      set count-fires count-fires + 1  ;increase the fire area counter
    ]
  ]
  set last_spark 0    ;reset

  wait 0.2
end


to ignite  ;; patch procedure
  set pcolor red
  set burned-trees-fire burned-trees-fire + 1        ;increase fire area measure
  ask neighbors4 with [pcolor = green] [ ignite ]    ;ignite neighbours in the von Neumann neighbourhood (recursive call!)
end
;;///FIRE PROCEDURES///



;;///UNGULATE PROCEDURES///
to move

  if(walk = "random")
  [ rt random 360 ]    ;if random walk, turn in a random direction

  if(walk = "directed")
  [
    let target nobody
    set target one-of neighbors with [ pcolor = green ]  ;set target direction a tree in the moore neighbourhood (radius 1)

    ifelse(target != nobody)  ;if there was a tree in the neighbourhood (if there was none, target would have remained nobody)
    [ face target ]
    [ rt random 360 ]  ;if no trees in the neighbourhood, turn a random direction
  ]

  fd 1  ;move forward a distance of 1

  set energy energy - 1     ;reduce energy (due to moving)

  if([pcolor] of patch-here = green)
  [
    set energy energy + energy-from-food   ;if tree here, gain energy
    ask patch-here [ set pcolor brown ]    ;remove the tree
  ]

end


to reproduce  ;; sheep procedure
  if random-float 100 < reproduction-rate [  ;; throw "dice" to see if you will reproduce
    set energy (energy / 2)                ;; divide energy between parent and offspring
    hatch 1 [ rt random-float 360 fd 1 set energy 10 ]   ;; hatch an offspring and move it forward 1 step
  ]
end
;;///UNGULATE PROCEDURES///





;;///PLOTTING PROCEDURES///
to plotting

  ;; for this plot, the axes are logarithmic, so we can't
  ;; use "histogram-from"; we have to plot the points
  ;; ourselves one at a time
  set-current-plot "Freq-Area Distribution (log-log)"
  plot-pen-reset  ;; erase what we plotted before

  ;; start plotting at degree one
  let area 1
  let min-limit 1
  let max-limit 1 + plot-interval
  let interval-counter 0

  let xvals []
  let yvals []

  while [area <= max-total-area]
  [
    let area-counter 0
    if not empty? burned-trees-total
    [
      set area-counter occurrences area burned-trees-total
      set interval-counter interval-counter + area-counter
    ]

    set area area + 1

    if area = max-limit
    [
      if interval-counter != 0
      [
        set xvals lput log ((min-limit + (max-limit - min-limit)) / 2) 10 xvals
        set yvals lput log interval-counter 10 yvals
        plotxy log ((min-limit + (max-limit - min-limit)) / 2) 10 log interval-counter 10
      ]
      set min-limit max-limit
      set max-limit min-limit + plot-interval
      set interval-counter 0
    ]
  ]

end

;; count the number of occurrences of an item in a list
to-report occurrences [x the-list]
  report reduce
    [ [occurrence-count next-item] -> ifelse-value (next-item = x) [occurrence-count + 1] [occurrence-count] ] (fput 0 the-list)
end
;;///PLOTTING PROCEDURES///
@#$#@#$#@
GRAPHICS-WINDOW
282
10
694
423
-1
-1
4.0
1
10
1
1
1
0
0
0
1
-50
50
-50
50
0
0
1
ticks
30.0

SLIDER
11
53
171
86
spark_freq
spark_freq
0.0000
0.01
0.003
0.001
1
NIL
HORIZONTAL

BUTTON
12
12
92
45
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
96
12
174
45
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
8
171
268
348
Freq-Area Distribution (log-log)
Area
Freq
2.0
3.0
0.0
2.0
true
false
"" ""
PENS
"default" 1.0 2 -16777216 true "" ""

SLIDER
12
129
130
162
energy-from-food
energy-from-food
0
50
10.0
1
1
NIL
HORIZONTAL

SLIDER
11
92
130
125
initial-ungulates
initial-ungulates
0
100
10.0
1
1
NIL
HORIZONTAL

MONITOR
356
451
437
496
Sparks:Fires
count-sparks / count-fires
3
1
11

PLOT
7
355
268
496
Trees/1000, log(area), ungulates/10
NIL
NIL
0.0
10.0
0.0
5.0
true
false
"" ""
PENS
"default" 1.0 0 -13840069 true "" "plot (count patches with [pcolor = green]) / 1000"
"pen-1" 1.0 1 -2674135 true "" "plot log (count patches with [pcolor = red] + 1 ) 10"
"pen-2" 1.0 0 -1184463 true "" "plot count ungulates / 10"

MONITOR
443
451
522
496
Max Area
max-area
0
1
11

MONITOR
612
450
679
495
ungulates
count ungulates
0
1
11

SLIDER
134
130
267
163
reproduction-rate
reproduction-rate
0
1
0.2
0.1
1
NIL
HORIZONTAL

SLIDER
135
93
268
126
initial-trees
initial-trees
0
100
50.0
1
1
%
HORIZONTAL

CHOOSER
176
42
268
87
walk
walk
"random" "directed"
0

MONITOR
525
451
607
496
Median Area
median burned-trees-total
1
1
11

MONITOR
293
452
350
497
Fires
count-fires
0
1
11

@#$#@#$#@
## WHAT IS IT?

This model is a combination of the simple FFCA (probability of fire spread = 1.0) and the Ungulate Browser models.

## HOW IT WORKS

Both FFCA and Ungulates models function as previously. Both fires and ungulates remove vegetation from the landscape. Fires do _not_ kill ungulates.  

## THINGS TO TRY

Compare behaviour of each model independently to when they interact here:
  
  * how do wildfire frequency-area distributions vary for different combinations of ungulate parameters?
  * how are ungulate populations influenced by presence of fire in the landscape?

## EXTENDING THE MODEL


  *Add variable probability of fire spread (e.g. increasing probability through time)
  * Include sophisticated vegetation searching abilities for ungulates (e.g. memory, Boyer and Walsh 2010) 
  * Add a second species of browsing agent
  * Add a predator agent


## RELATED MODELS

FFCA
Ungulates
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="3" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>count-fires = 150</exitCondition>
    <metric>count-sparks / count-fires</metric>
    <metric>max-area</metric>
    <metric>median burned-trees-total</metric>
    <enumeratedValueSet variable="walk">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="spark_freq">
      <value value="0.004"/>
      <value value="0.006"/>
      <value value="0.008"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-trees">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="energy-from-food">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reproduction-rate">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-ungulates">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
