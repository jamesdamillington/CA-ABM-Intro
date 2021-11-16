;global variables
globals
[
  percent-similar  ;; on the average, what percent of a household's neighbors
                   ;; are the same shape as that household?
  percent-unhappy  ;; what percent of the household are unhappy?
]


;turtle variables
turtles-own
[
  happy?           ;; for each turtle (representing a household), indicates whether at least %-similar-wanted percent of
                   ;; that households' neighbors are the same shape as the household
  same-nearby      ;; how many neighboring patches have a household with my shape?
  different-nearby ;; how many have a household of another shape?
  total-nearby     ;; sum of previous two variables
]



to setup

  clear-all

  if number > count patches  ;check we're not try to create more households than there is space for!
  [
    user-message (word "This space only has room for " count patches " turtles.")
    stop
  ]

  ;; create households on random patches
  ask n-of number patches
  [
    sprout 1 [ set shape "circle" set color [117 112 179] ] ]

  ;; turn half the households to stars
  ask n-of (number / 2) turtles
    [ set shape "star" ]

  ;update-happiness

  reset-ticks

end

to go

  update-happiness                     ;execute the update-happiness procedure

  if all? turtles [happy?] [ stop ]    ;stop simulation if everyone is happy

  move-unhappy-households              ;execute the move-unhappy-households procedure

  tick                                 ;increase ticks by 1 (needed for the plots)

end

to move-unhappy-households

  ask turtles with [ not happy? ]      ;if household is not happy
      [ find-new-location ]            ;excute the find-new-location procedure

end

to find-new-location

  ;random walk
  rt random-float 360              ;; turn right a random number of degrees from 0 to 359
  fd random-float 10               ;; move forward a distance of 10 units

  ;assess current location
  if any? other turtles-here       ;; if this location is already occupied
    [ find-new-location ]          ;; repeat this procedure until we find an unoccupied patch

  ;move to the location identified
  move-to patch-here               ;; move to center of patch

end

to update-happiness

  update-households                ;execute the update-households procedure
  update-globals                   ;execute the update-globals procedure

end

to update-households

  ask turtles
  [
    ;; in next two lines, we use "neighbors" to test the eight patches
    ;; surrounding the current patch
    set same-nearby count (turtles-on neighbors) with [shape = [shape] of myself]
    set different-nearby count (turtles-on neighbors) with [shape != [shape] of myself]

    set total-nearby same-nearby + different-nearby  ;set the total-nearby variable to the sum of the same-nearby and different-nearby

    ;calculate if the household is happy
    set happy? same-nearby >= ( %-similar-wanted * total-nearby / 100 )

    ;change the colour of the household depending on whether they are happy or not
    ifelse(happy?)
    [ set color [27 158 119] ]
    [ set color [217 95 2] ]
  ]

end

to update-globals

  let same-neighbors sum [same-nearby] of turtles                                ;for ALL HOUSEHOLDS add up the number of same neighbours
  let total-neighbors sum [total-nearby] of turtles                              ;for ALL HOUSEHOLDS add up the total number of neighbours
  set percent-similar (same-neighbors / total-neighbors) * 100                   ;using last two counts, calculate proportion of same neighbours that are similar
  set percent-unhappy (count turtles with [not happy?]) / (count turtles) * 100  ;use last calculation to calculate % of households unhappy

end
@#$#@#$#@
GRAPHICS-WINDOW
343
10
708
376
-1
-1
7.0
1
10
1
1
1
0
1
1
1
-25
25
-25
25
1
1
1
interations
30.0

MONITOR
263
330
339
375
% unhappy
percent-unhappy
1
1
11

MONITOR
264
187
339
232
% similar
percent-similar
1
1
11

PLOT
13
141
262
284
Percent Similar
time
%
0.0
5.0
0.0
100.0
true
false
"" ""
PENS
"percent" 1.0 0 -14835848 true "" "plot percent-similar"

PLOT
12
286
261
429
Percent Unhappy
time
%
0.0
5.0
0.0
100.0
true
false
"" ""
PENS
"percent" 1.0 0 -2269166 true "" "plot percent-unhappy"

SLIDER
14
22
262
55
number
number
500
2500
2050.0
10
1
NIL
HORIZONTAL

SLIDER
14
97
261
130
%-similar-wanted
%-similar-wanted
0
100
65.0
1
1
%
HORIZONTAL

BUTTON
13
59
85
92
setup
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
187
59
262
92
go
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

BUTTON
99
59
176
92
go once
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

This model represents the behaviour of two types of 'household' in a hypothetical city space based on their 'happiness' with the composition of their local neighbourhood.

The star households and circle households get along with one another. But each household wants to make sure that it lives near some of "its own." That is, each star household wants to live near at least some star households, and each circle household wants to live near at least some circle households. Households determine if they are happy as in the _Happiness in Schelling's World_ model (Millington 2021). 

This model extends the the _Happiness in Schelling's World_ model (Millington 2021) by enabling households to move if they are unhappy with the composition of their local neighbourhood. It does this by moving unhappy households to randomly selected locations in the city, where the household again assess if they are happy or not. By repating (iterating) this process over and over, the simulation of the model shows how individual preferences ripple through the city, leading to large-scale patterns (of segregation).

The idea was inspired by Thomas Schelling's writings about segregation, such as housing patterns in cities (Schelling 1978, Rauch 2002). The code and project was developed from the _NetLogo Segregation_ model (Wilesky 1997) and builds on the _Happiness in Schelling's World_ model (Millington 2021). Colours have been selected from [ColorBrewer](https://colorbrewer2.org) to be colourblind safe.

## HOW TO USE IT

Click the SETUP button to set up the households. There are equal numbers of star and circle households. 

Click GO to start the simulation. The households move around until there is at most one household on a patch. If households don't have enough same-shape neighbours, they move to a random nearby patch. This repeats until all households are happy (or continues forever!)

Click GO ONCE to simulate the movement of households once (i.e. one iteration of the go procedure). 

The NUMBER slider controls the total number of households. (It takes effect the next time you click SETUP.)  

The %-SIMILAR-WANTED slider controls the percentage of same-shape household that each household wants among its neighbours. For example, if the slider is set at 30, each star household wants at least 30% of its neighbours to be star households.

The % SIMILAR monitor shows the average percentage of same-colour neighbours for each household. It starts at about 50%, since each household starts (on average) with an equal number of star and circle households as neighbors. 

The % UNHAPPY monitor shows the percent of households that have fewer same-shape neighbours than they want (and thus want to move). Both monitors are also plotted through time.

The number of times move-unhappy-households procedure has been repeated is shown as the number of iterations (above the model grid, top centre)

## THINGS TO NOTICE

Households turn a green colour when they are happy, and a red (orange) colour when they are unhappy. When you click SETUP, the star and circle households are randomly distributed throughout the space. But many households are "unhappy" since they don't have enough same-shape neighbours. 

When you click GO ONCE, the unhappy households move to random new locations in the city. They may be happy or unhappy with their new location (i.e. households do not seek locations where they will know they will be happy, but rather move randomly). Regardless of their own happiness in the new locations, households might tip the balance of the nehighbourhood population they have moved to, prompting other households to leave! If a few star households move into an area, the local circle households might leave. But when the cirle households move to a new area, they might prompt star households to leave that area. See if you can observe this happening (although it can be quite difficult in this large model). 

When you click GO, the process above is repeated (iterated) until all households are happy. Notice that sometimes this continues forever! Why is this?

## THINGS TO TRY

1. For 2000 households, if each household wants at least 10% same-shape neighbours, what percentage (on average) do they end up with? How many iterations (repeats) does it take for all households to be happy? 
 
2. Repeat 2. for 33%, 50%, 66% and 90%. How does the overall degree of segregation change? Working through values systematically like this, recording your results, is a scientific approach. 

3. Repeat 1. and 2. for different numbers of households in the space. Does this influence results? Why or why not?

## REFERENCES

Millington, J.D.A. (2021) Happiness in Schelling's World. NetLogo model. http://www.landscapemodelling.net/models/schelling

Rauch, J. (2002). Seeing Around Corners; The Atlantic Monthly; April 2002;Volume 289, No. 4; 35-48. http://www.theatlantic.com/issues/2002/04/rauch.htm

Schelling, T. (1978). Micromotives and Macrobehavior. New York: Norton.

Wilensky, U. (1997).  NetLogo Segregation model.  http://ccl.northwestern.edu/netlogo/models/Segregation.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE

The original work by Willensky (1997) was licensed under the [Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License](http://creativecommons.org/licenses/by-nc-sa/3.0/).

![CC BY-NC-SA 3.0](http://i.creativecommons.org/l/by-nc-sa/3.0/88x31.png)

This work is licensed by [James D.A. Millington](http://www.landscapemodelling.net) under the [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-nc-sa/4.0/). 
 
![CC BY-NC-SA 4.0](https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png)

This work should be cited as:
Millington, J.D.A. (2021) Schelling's Segregation Shapes. NetLogo model. http://www.landscapemodelling.net/models/schelling
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
NetLogo 6.1.1
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
