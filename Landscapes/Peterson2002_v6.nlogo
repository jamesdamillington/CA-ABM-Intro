;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                              ;;
;;                    Ecological Memory Model - May 2015                        ;;
;;                                                                              ;;
;;  Code licenced by James D.A. Millington (http://www.landscapemodelling.net)  ;;
;;  under GNU GPLv2 https://www.gnu.org/licenses/gpl-2.0.html                   ;;
;;                                                                              ;;
;;  Model code and documentation available on:                                  ;;
;;  http://github.com/jamesdamillington/KeyMethodsInGeography                   ;;
;;                                                                              ;;
;;  Model used in:                                                              ;;
;;  Millington, J.D.A. (2015) Simulation and reduced complexity models          ;;
;;  In Clifford et al. (Eds) Key Methods in Geography London: SAGE              ;;
;;                                                                              ;;
;;  Based on:                                                                   ;;
;;  Peterson, G. D. (2002). Contagious disturbance, ecological memory, and      ;;
;;  the emergence of landscape pattern. Ecosystems 5(4) 329-338.                ;;
;;                                                                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


globals
[
  alpha           ;alpha parameter - see Peterson 2002
  p-max           ;maximum probability threshold
  ignitions       ;frequency of fire ignition
  fire-front      ;agent-set to simulate fire
  max-tsf         ;maximum time since fire
]


patches-own
[
  tsf       ;time since fires
  pfs       ;probability of fire spread
]


to setup

  ca
  reset-ticks

  set alpha 10 ^ log-alpha
  set p-max 0.24
  set ignitions ignition-rate * (world-height / 100) ;scale ignitions

  ask patches
  [
    set tsf 1
    set pfs set-pfs tsf
    set pcolor scale-color lime tsf tp-max 0
  ]

  update-plots

end


to-report set-pfs [ age ]   ;patch procedure

  ifelse(age > tp-max)
  [ report p-max ]
  [ report p-max * (age / tp-max) ^ alpha ]

end


to go

  ask patches [ set pcolor scale-color lime tsf tp-max 0 ]  ;set colour of patches

  repeat ignitions
  [ ignite ]

  ask patches
  [
    set tsf tsf + 1         ;update time since fires
    set pfs set-pfs tsf     ;after updating tsf update pfs
  ]

  set max-tsf max [tsf] of patches

  tick

end


; Code for 'ignite' procedure by George L.W. Perry, University of Auckland (http://web.env.auckland.ac.nz/people_profiles/perry_g/)
to ignite

  ask one-of patches
  [
    set tsf 0
    set fire-front patch-set self ;; a new fire-front
    spread
  ]

end


; Code for 'spread' procedure modified from code by George L.W. Perry, University of Auckland (http://web.env.auckland.ac.nz/people_profiles/perry_g/)
to spread

  while [ any? fire-front ]  ;; stop when we run out of fire-front
  [
    let new-fire-front patch-set nobody ;; empty set of patches for the next 'round' of the fire
    ask fire-front
    [
      set pcolor red
      let N neighbors with [ tsf > 0]
      ask N
      [
        if random-float 1 <= pfs
        [
          set tsf 0
          set new-fire-front (patch-set new-fire-front self) ;; extend the next round front
        ]
      ]
    set fire-front new-fire-front
    ]
  ]

end
@#$#@#$#@
GRAPHICS-WINDOW
238
16
907
686
-1
-1
1.5
1
10
1
1
1
0
0
0
1
-220
220
-220
220
1
1
1
ticks
30.0

SLIDER
27
151
199
184
log-alpha
log-alpha
-2
2
0.0
0.5
1
NIL
HORIZONTAL

SLIDER
26
191
198
224
tp-max
tp-max
0
50
24.0
1
1
NIL
HORIZONTAL

BUTTON
17
13
84
46
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

MONITOR
29
93
86
138
alpha
alpha
2
1
11

SLIDER
28
51
200
84
ignition-rate
ignition-rate
0
16
4.0
1
1
NIL
HORIZONTAL

MONITOR
141
94
199
139
NIL
ignitions
0
1
11

BUTTON
86
13
149
46
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
14
406
214
556
tsf
NIL
NIL
0.0
100.0
0.0
1000.0
true
false
"" ""
PENS
"default" 10.0 1 -16777216 true "" "clear-plot\nhistogram [tsf] of patches"

PLOT
14
562
214
712
pfs
NIL
NIL
0.0
0.5
0.0
10.0
true
false
"" ""
PENS
"default" 0.05 1 -16777216 true "" "histogram [pfs] of patches"

PLOT
13
246
213
396
TSF Curve
tsf
pfs
0.0
50.0
0.0
0.25
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "clear-plot\nlet t 0\nlet reps (tp-max + 5)\nrepeat reps\n[\n  let p (p-max * (t / tp-max) ^ alpha)\n  ifelse(t <= tp-max)\n  [ plotxy t p ]\n  [ plotxy t p-max ]\n  set t t + 1\n]"

BUTTON
153
13
216
46
step
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

This model is a replication of that described by Peterson (2002) and illustrates a spatial 'spread' feedback loop (a form of 'ecological memory'). In spread feedback, spatial patterns influence spread processes which influence later spatial patterns and hence later spread processes. In ecology, this concept of processes being shaped by their history is known as the ‘memory’ of the process (Peterson 2002). For wildland fire, memory – and therefore feedbacks between spread and spatial pattern – has been conceptualized as being contained in vegetation flammability as a function of time since last the fire. In this model version red patches indicate areas burned in a given time step, green patches the length of time since the last fire at that location (lighter, fire more recently). 

## HOW IT WORKS

The simulated environment contains vegetation, the flammability (probability of spread, _pfs_) of which is governed by time since last fire (_tsf_). In each timestep a given number of fires are ignited at randomly selected locations in the simulated environment. Fires spread to neighbouring locations determined by the vegetation flammability. The number of fires ignited in each timestep is set by the user, as is the relationship between _pfs_ and _tsf_). 

## HOW TO USE IT

First, set the number of ignitions per timestep by moving the _ignition-rate_ slider (larger number will result in more fires per timestep). Next, determine the relationship between _tsf_ and _pfs_ by moving the _log-alpha_ and _tp-max_ sliders. The relationship between _tsf_ and _pfs_ for the selected values can be observed in the _TSF Curve_ plot by clicking _setup_ (the number of fires per timestep will also be displayed in the _ignitions_ monitor). See Peterson (2002, p.332) for details of how _log-alpha_ (via _alpha_, the memory parameter) and _tp-max_ influence the shape of the _TSF Curve_. 

Click _Go_ to run the simulation. If the model runs slowly on your machine you can try reducing the total area of the environment (right-click environment, click edit, then reduce the _world-width_ and _world-height_ values). 

## THINGS TO NOTICE

Notice how recently burned patches are less likely to burn in a given time step, and so the pattern of previous burns influences contemporary burns (with fires more likely to burn dark areas in the previous time step). The proportion of the landscape with different _tsf_ and _pfs_ values are shown by the histogram plots. 

## THINGS TO TRY

Try changing the _log-alpha_ value (producing different values for _alpha_, the memory parameter) to change the _TSF Curve_ and the _ignition-rate_ value to change the number of ignitions per timestep. Look at how these changes influence the size of fires and how restricted they are by patterns of vegetation.

## CREDITS AND REFERENCES

Millington, J.D.A. (2015) Simulation and reduced complexity models In Clifford et al. (Eds) _Key Methods in Geography_ London: SAGE                    

Peterson, G. D. (2002). Contagious disturbance, ecological memory, and the emergence of landscape pattern. _Ecosystems_ 5(4) 329-338.

Code licenced by James D.A. Millington (http://www.landscapemodelling.net) under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License (see http://creativecommons.org/licenses/by-nc-sa/3.0/)                                                                                   


Model code and documentation available on: http://github.com/jamesdamillington/KeyMethodsInGeography   
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

sheep
false
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

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
