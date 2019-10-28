# Landscape CA and ABM Tutorial
This tutorial presents some simple cellular automata (CA) and agent-based models (ABM) to see how such approaches might help to investigate environmental and landscape dynamics and change. In particular, we will focus on the interaction of vegetation, wildfire and browsing ungulates. 

The tutorial uses the NetLogo modelling environment, freely available from: http://ccl.northwestern.edu/netlogo/ Download model files where indicated to your computer, then open the file from NetLogo to experiment.   

## The Forest Fire Cellular Automata
The forest-fire cellular automata (FFCA) model rose to prominence in the late 1980s as researchers examined the theory of self-organized criticality in dynamical systems. Self-organized criticality is the idea that dynamical systems order themselves to a ‘critical’ state (where small inputs can produce outputs of any size) regardless of initial conditions and independent of any exogenous driving force. The FFCA, its construction and implications, is well described in Millington et al. (2006). 

In the FFCA trees and sparks are dropped in random locations with specified frequency. If a spark falls on a tree the tree burns and the fire spreads (with probability = 1) to any neighbouring trees. The primary observation of the FFCA is that power-law area-frequency distributions are produced regardless of the frequencies of tree and sparks drops (provided differences in frequencies are relatively large). The distributions are characterised by very many fires of very small area and very few fires with very large fires (i.e. very different from a ‘normal’ distribution). 

From the FTP site [ftp://137.73.142.19/volcano/NERC%20DTP%20Teaching/Modeling%20Landscapes/CA_ABM/] download the file FFCA.nlogo [right-click link and save as] file to the desktop and open it in NetLogo. Experiment with different values of spark_freq to see how a power-law frequency-area distribution is always produced. 

The model inspired researchers to later search for similar frequency-area distributions in real world landscapes (e.g. Malamud et al. 1998, Malamud et al. 2005).

## Ungulate Agents
A fundamental stochastic model used in simulation models to represent and investigate the movements of individuals through space and time is known as a random walk. Such walks can be truly random, correlated or directed. A primary example of when random walks are used in biology and ecology is to represent and investigate foraging and searching for resources (e.g. Boyer and Walsh 2010). Here we’ll examine a simple model of ungulates moving through a landscape consuming vegetation. Download and open the Ungulates.nlogo file in NetLogo.

In the model, ungulates move through the landscape using either a random walk or a directed walk (set by the walk chooser). If random, ungulates turn to a random direction. If directed, ungulates turn to face any vegetation in the eight surrounding patches (known as the Moore neighbourhood), otherwise they turn to a random direction. In both cases, after turning ungulates move forward a distance of one patch. Each time they move ungulates use up (subtract) one unit of energy. After moving, if vegetation is present in the patch the ungulate is at, the ungulate eats the vegetation, removing it from the landscape and gaining an amount of energy specified by energy-from-food.

First, play with the model to understand properly how each type of walk operates. Answer the following questions:
1. How ‘efficient’ are the two different walking strategies? 
2. What indicates this efficiency? 
3. How does the influence of `energy-from-food` parameter vary between the two different types of walk? 

Second, examine system dynamics more systematically. To do this you will need to decide what the ‘state variable’ of your model system is; a state variable is a variable that describes (or measures) the state of the system (e.g. number of trees, number of ungulates). You will also need to think about how you will systematically vary the (input) parameter values to examine their influence on the state variable. A parameter specifies some magnitude of relationship between variables or entities for a given model structure (parameters here include `energy-from-food`, for example). You will need to think about what the lower parameter values will be, what the largest will be and what interval between you examine. In an agent-based model like this you can also modify the rule of behaviour of the agents (e.g. the walking strategy). **Create an Excel spreadsheet or similar to store your results for comparison, including plotting the output in figures.**

Third, think about how you might extent the model to represent and investigate more sophisticated vegetation searching abilities for ungulates (e.g. memory; Boyer and Walsh 2010). What rules might you want to add? Do you think you could quickly modify the code to do this? See the [NetLogo Tutorials](https://ccl.northwestern.edu/netlogo/docs/) for more about the language and how it is structured (go online or within the NetLogo software go to Help -> NetLogo User Manual).

## Ungulates, Vegetation and Fire
To show how different the two different types of model (CA and ABM) can be combined we’ll look at model that combines the FFCA with the Ungulate Browser model. In this model both FFCA and Ungulates models function as previously. Both fires and ungulates remove vegetation from the landscape. Fires do not kill ungulates. 

Download and open the FFCA_Ungulates.nlogo file in NetLogo. 

Compare behaviour of each model independently to when they interact here. Answer the following questions:
1. How do wildfire frequency-area distributions vary for different combinations of ungulate parameters? 
2. How are ungulate populations influenced by presence of fire in the landscape? 
3. As in Section 2, decide what your state variable/s is/are and how you will vary parameter to ensure systematic comparison. How will you organise and store your results to enable this?

## Further Models
Another model available to download (Peterson2002.nlogo) explores the importance of memory in landscapes and ecological systems, again using wildfire and vegetation as an example. The model is an implementation of that investigated by Peterson (2002). Feel free to explore this model and understand the relationship between spatial contagion and ecological memory in conjunction with the paper. 

## Reading
