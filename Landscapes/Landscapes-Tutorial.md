# Landscapes CA and ABM Tutorial
This tutorial presents some simple cellular automata (CA) and agent-based models (ABM) to see how such approaches might help to investigate environmental and landscape dynamics and change. It exemplifies some of the concepts introducted in [Millington (2023)](#further-reading). In particular, we will focus on the interaction of vegetation, wildfire and browsing ungulates. 

The tutorial uses the [NetLogo](http://ccl.northwestern.edu/netlogo/) (version 6) modelling environment, freely available to [download here](https://ccl.northwestern.edu/netlogo/download.shtml). Alternatively, you can try running the models below in the online  [Netlogo Web](https://www.netlogoweb.org/launch#NewModel) version.

If you are unfamiliar with the NetLogo modelling environment, you may find it useful to review [their first tutorial](https://ccl.northwestern.edu/netlogo/docs/tutorial1.html). At a minimum you should understand what the different elements of the [NetLogo Interface Tab](https://ccl.northwestern.edu/netlogo/docs/interfacetab.html) are (i.e. sliders, choosers, etc).   

Download model files, where indicated in the instructions below, to your computer (using right-click, then Save As...), then open the file _from NetLogo_ (or upload to Netlogo Web) to experiment with the models.   

## 1. The Forest Fire Cellular Automata
The forest-fire cellular automata (FFCA) model rose to prominence in the late 1980s as researchers examined the theory of self-organized criticality in dynamical systems. Self-organized criticality is the idea that dynamical systems order themselves to a 'critical' state (where small inputs can produce outputs of any size) regardless of initial conditions and independent of any exogenous driving force. The FFCA, its construction and implications, is well described in [Millington et al. (2006)](https://doi.org/10.1144/GSL.SP.2006.261.01.12) (available for [download here](http://www.academia.edu/download/3460910/Millington_etal_2006.pdf)).

In the FFCA, trees and sparks are dropped in random locations with specified frequency. If a spark falls on a tree the tree burns and the fire spreads (with probability = 1) to any neighbouring trees. The primary observation of the FFCA is that power-law area-frequency distributions are produced _regardless_ of the frequencies of tree and spark drops (provided that differences between the frequencies are relatively large). The distributions are characterised by very many fires of very small area and very few fires of very large area (i.e. very different from a 'normal' distribution).

Download (right-click, save as) the file [FFCA_v6.nlogo](https://raw.githubusercontent.com/jamesdamillington/CA-ABM-Intro/master/Landscapes/FFCA_v6.nlogo) (right-click link and save as) file to your computer and open it in NetLogo (or upload to NetLogo Web).

### Task 1
_Experiment with different values of `spark_freq` to see how a power-law frequency-area distribution is always produced._

The FFCA inspired researchers to later search for similar frequency-area distributions in real world landscapes. For example, see [Malamud et al. 1998](https://doi.org/10.1126/science.281.5384.1840), [Malamud et al. 2005](https://doi.org/10.1073/pnas.0500880102) - you may like to follow-up on some of these studies.

## 2. Ungulate Agents
A fundamental stochastic model used in simulation models to represent and investigate the movements of individuals through space and time is known as a random walk. Such walks can be truly random, correlated or directed. A primary example of when random walks are used in biology and ecology is to represent and investigate foraging and searching for resources (e.g. [Boyer and Walsh 2010](https://doi.org/10.1098/rsta.2010.0275)). Here, we'll examine a simple model of ungulates moving through a landscape consuming vegetation. Download (right-click, save as) and open the [Ungulates_v6.nlogo](https://raw.githubusercontent.com/jamesdamillington/CA-ABM-Intro/master/Landscapes/Ungulates_v6.nlogo) file in NetLogo (or upload to NetLogo Web).

In the model, ungulates move through the landscape using either a _random walk_ or a _directed walk_ (set by the walk chooser). If _random_, ungulates turn to a random direction. If _directed_, ungulates turn to face any vegetation in the eight surrounding patches (known as the Moore neighbourhood), otherwise (if no vegetation exists in the Moore neighbourhood) they turn to a random direction. In both cases, after turning ungulates move forward a distance of one patch. Each time they move, ungulates use up (subtract) one unit of energy. After moving, if vegetation is present in the patch the ungulate is at, the ungulate eats the vegetation, removing it from the landscape and gaining an amount of energy specified by `energy-from-food`.

### Task 2a
_Work with the model to understand properly how each type of walk operates._

### Task 2b
 _Answer the following questions_:
1. Which walking strategy is most 'efficient'?
2. How did you arrive at your answer for Q1? (i.e. what indicates this efficiency?)
3. How does the influence of `energy-from-food` parameter vary between the two different types of walk?

### Task 2c
_Examine system dynamics more systematically: create an Excel spreadsheet or similar to store your results for comparison, including plotting the output in figures._

 To do this will need to:
 - Decide what the 'state variable' of your model system is; a state variable is a variable that describes (or measures) the state of the system (e.g. number of trees, number of ungulates).
 - Think about how you will systematically vary the (input) parameter values to examine their influence on the state variable. A parameter specifies some magnitude of relationship between variables or entities for a given model structure (parameters here include `energy-from-food`, for example).
 - Think about what the lower parameter values will be, what the largest will be and what interval between you examine. In an agent-based model like this you can also modify the rule of behaviour of the agents (e.g. the walking strategy).

### Additional Task
 _Think about how you might extend the model to represent and investigate more sophisticated vegetation searching abilities for ungulates_

What rules might you want to add?  For example, how could you incorporate agent memory (e.g., [Boyer and Walsh 2010](https://doi.org/10.1098/rsta.2010.0275)). You will need to learn more about how NetLogo works to do this - see the [NetLogo Tutorials](https://ccl.northwestern.edu/netlogo/docs/tutorial1.html) and the User Manual [online](https://ccl.northwestern.edu/netlogo/docs/) (within the NetLogo software go to Help -> NetLogo User Manual) for more about the NetLogo language and how it is structured.

## 3. Ungulates, Vegetation and Fire
To show how different the two different types of model (CA and ABM) can be combined we'll look at model that combines the FFCA with the Ungulate Browser model. In this model both FFCA and Ungulates models function as previously. Both fires and ungulates remove vegetation from the landscape. Fires do not kill ungulates.

Download (right-click, save as) and open the [FFCA_Ungulates_v6.nlogo](https://raw.githubusercontent.com/jamesdamillington/CA-ABM-Intro/master/Landscapes/FFCA_Ungulates_v6.nlogo) file in NetLogo (or upload to NetLogo Web).

### Task 3a
_Contrast the behaviour of each model independently to their interactions in this combined model, and answer the following questions:_
1. How do wildfire frequency-area distributions vary for different combinations of ungulate parameters?
2. How are ungulate populations influenced by the presence of fire in the landscape?

### Task 3b
_Create an Excel spreadsheet or similar to store your results for comparison, including plotting the output in figures._

As in Section 2, decide what your state variable/s is/are and how you will vary parameters to ensure systematic comparison.

## Further Models
Another model available to download - [Peterson2002_v6.nlogo](https://raw.githubusercontent.com/jamesdamillington/CA-ABM-Intro/master/Landscapes/Peterson2002_v6.nlogo) - explores the importance of memory in landscapes and ecological systems, again using wildfire and vegetation as an example. The model is an implementation of that investigated by [Peterson (2002)](https://doi.org/10.1007/s10021-001-0077-1). Feel free to explore this model and understand the relationship between spatial contagion and ecological memory in conjunction with the paper.

## Further Reading
An, L., Grimm, V., Sullivan, A., et al. (2021) [Challenges, tasks, and opportunities in modeling agent-based complex systems](https://doi.org/10.1016/j.ecolmodel.2021.109685). _Ecological Modelling_, 457, 109685.

Bithell, M., Brasington, J., & Richards, K. (2008) [Discrete-element, individual-based and agent-based models: Tools for interdisciplinary enquiry in geography?](https://doi.org/10.1016/j.geoforum.2006.10.014) _Geoforum_, 39(2), 625-642

Millington, J.D.A. (2023) Simulation and reduced complexity models _In:_ Clifford et al. (Eds.) _[Key Methods in Geography.](https://uk.sagepub.com/en-gb/eur/key-methods-in-geography/book277816)_ (4th ed.) London: SAGE, 445-469. _[Previous version available here](http://landscapemodelling.net/pdf/paper/Millington_2016_Ch-24_Clifford2016.pdf)_

O'Sullivan, D., & Perry, G. L. (2013) _[Spatial Simulation: Exploring Pattern and Process.](http://patternandprocess.org/)_ London: Wiley-Blackwell

Railsback, S. F., & Grimm, V. (2019) _[Agent-based and individual-based modeling: a practical introduction.](http://www.railsback-grimm-abm-book.com/)_ Princeton University Press
