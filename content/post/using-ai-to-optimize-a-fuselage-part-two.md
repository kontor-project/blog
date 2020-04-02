---
title: "Using Ai to Optimize a Fuselage Part Two"
date: 2020-02-27T17:29:00-04:00
draft: false
---

Two weeks ago we saw how to optimize a fuselage's cross-sectional area using OpenVSP as a heuristic. The point of this exercise was to see if could design the most basic optimization algorithm. The outcome of the exercise was easy to predict; as an object's cross-sectional area reduces, so does its drag coefficient. So we wrote a simple 1 dimensional hill climb algorithm, that decreased its stepping distance time ran out. The results were what we expected. Now we can try to do something a bit more complex: messing with the wires that connect cross-sections of the fuselage.

# The Problem

Let's begin by seeing what we can control with OpenVSP. For each cross-section of the `FuselageBase` we have a `Skinning` tab, which allows us to modify the "mesh of wires" that connect one cross-section to another. For each cross-section we have 4 parts (top, right, left, bottom) which have properties `angle`, `slew`, `strength` and `curvature`. We'll stick to `angle`, `slew` and `strength` for now, because `curvature` is a little to complex (and it's disabled by default). This means we have 3 variables which can change independently on 7 different segments. Assuming we can only change one attribute for each step (for example the left slew of the 4th cross-section by 10%), we can have a total of 84 potential next steps. We might be tempted to optimize one cross-section at a time in order to simplify our algorithm, which for other problems might be perfectly acceptable, but in this case is a trap. Let's see a simple example to make this point: imagine our algorithm finds that setting the angle of cross-section 4 to be parallel to the `y` axis (as in: horizontal) is the way to go. If we then move on to cross-section 5, we will be forced to find the most aerodynamic angle based on the fact that the "wire mesh" coming from cross-section 4 is horizontal. This might not be as efficient as having cross-section 4 with an angle around -5°. If we treat every cross-section independently, we will miss out on these possibilities. Furthermore, the solution space for this case is slightly stranger than the previous problem; I honestly cannot tell if a pointy tip is better than a round tip.

![Image](/using-ai-to-optimize-fuselage-part-two/round-vs-pointy.jpg)

This is the big difference between this problem and the last; now we cannot assume anything about the solution space, and we have a multidimensional solution space to explore, meaning we don't only have two directions we could be headed towards (increasing or decreasing the area for the previous problem), we have 84 of them. We will need a more sophisticated algorithm. But before we get into the algorithm, let's define our boundary conditions. There are one and a half:

1. The back of the fuselage needs to remain perpendicular to the `y` axis (as in: vertical). The reason for this is so the propeller can have enough clearance from its axis to the `FuselageTail`. We can easily achieve this by skipping cross-sections 1, 2 and 3 (or 0, 1, 2 in programming terms).

2. The front of the fuselage has to arch just enough to leave room for the pilot's feet. I am seriously tempted to just assume this will naturally happen, or that the seating position can be rearranged afterwards. You see, it will be a rather nasty job to find a way to tell if we're past the boundary or not, and frankly, the seating pilot's position is aleatory. As long as it "looks natural", we can get by.

Right, now let's experiment with three different ways to explore the solution space we created: hill climb, simulated annealing and a genetic algorithm.

# Hill Climb

Starting with a similar system to what we used to minimize the fuselage's cross-sectional area, we can see if we can minimize drag by slowly improving the airplanes frame using feedback from our simulation. For this, we will have to observe every nearby possible state, analyze it, and pick the best of them all. This will guarantee that we will find a minimum/maximum in our solution space. And if your solution space only has one minimum/maximum point, we are guaranteed to find **THE** best solution. Think of it like trying to climb a pyramid while blindfolded. If there is a stone next to you that is higher than the one you are on, you move to that stone. If there are none, then you are at the top. The algorithm for this is almost as easy as it sounds:

```python
# find and benchmark all neighboring states
for i in range(3, len(sections)):
      pass
      for element in sections[i]:
          pass
          # if 'Angle' in element and 'Top' in element:
          if 'Angle' in element or 'Strength' in element or 'Slew' in element:
              pass
              child = Node(model, i, element, (1 + c), child_number, children)
              child.start()
              child.append(child)
              child_number += 1

              child = Node(model, i, element, (1 - c), child_number, children)
              child.start()
              child.append(child)
              child_number += 1

# set the best one as the parent
for child in children[:]:
      if child.h < parent.h:
          parent = child
```

Now we press play and watch it take its sweet sweet time until we kill the process and go curse the world for a bit. You see, loading each file, making a change, saving it and running a simulation for 480 states takes too long. I couldn't go more than 1 iteration in less than 1h (imagine 100 of them). We should've thought this out before starting it. The problem has to do with the `openVSP` api not supporting multiple instances on the same process. This means, that we can only open, modify and test one model each time. That's a bummer... but there is a *questionable* workaround. Python supports multiprocessing with the `multiprocessing` library. We can create a job for each state we want to explore, and set it loose as a subprocess. This will allow us to benchmark all 480 states in parallel (not exactly all at once, but some). First we're going to add a function to run the open, modify, heuristic tasks:

``` python
def detached_worker(model, i, element, c, child_number, children):
    pass
    value = model['FuselageBase']['XSec'][i][element]['value'] * c
    id = model['FuselageBase']['XSec'][i][element]['_id']
    # create new node
    child = Node(child_number=child_number + 1, model=model)
    child.set_model_param(id=id, value=value)
    # sometimes we get h = 0 becaumax_workers = 4 # max number of subproccesses allowedse of who knows
    children.append(child)
```

Then we're going to set a constant that tells the algorithm how many of these workers it can have in parallel (if we have all 480 states running in parallel, we're going to die), and we'll add some system to wait for all workers to finish once the number of active workers reaches that threshhold:

```python
max_workers = 4 # my number of processors

'''
Inside the loop
'''
  manager = multiprocessing.Manager()
  parent.load_model()
  model = parent.get_model()
  sections = model['FuselageBase']['XSec']
  jobs = []
  child_number = 0
  children = manager.list()

  for i in range(3, len(sections)):
      pass
      for element in sections[i]:
          pass
          # if 'Angle' in element and 'Top' in element:
          if 'Angle' in element or 'Strength' in element or 'Slew' in element:
              pass
              child = multiprocessing.Process(target=detached_worker, args=(model, i, element, (1 + c), child_number, children, ))
              child.start()
              jobs.append(child)
              child_number += 1

              child = multiprocessing.Process(target=detached_worker, args=(model, i, element, (1 - c), child_number, children, ))
              child.start()
              jobs.append(child)
              child_number += 1

          if len(jobs) >= max_workers:
              print('waiting for children...')
              for child in jobs:
                  pass
                  child.join()
              jobs = []

  pool = multiprocessing.Pool(processes=child_number)
  # children = pool.map(child, [c for c in range(child_number)])
  print('done')
  pool.close()
```

I set the maximum number of workers to 4, because I have 4 cores in my processor. This should (in theory) decrease the time required to run the algorithm by 4. Now we can let the script run for a few hours, and see the results:

![Image](/using-ai-to-optimize-fuselage-part-two/hill-climb-results.png)

`h = 0.03804125029369643`

Pointy it is then... I've never seen a fuselage like that in my life. Maybe you have, but we can safely agree that it looks odd. This might have something to do with our algorithm choice. Hill climb assumes that there is one only best solution in the entire solution space. But what if there is more than one? What if there are multiple good solutions, but one that is better than the others? Imagine you are blind, and you climbed a pyramid in a field of pyramids. How can you tell that you are on the tallest one? And if you didn't climb it yet, how can you tell which is going to be the tallest without brute forcing your way up every pyramid? Let's look at another algorithm.

# Simulated Annealing

This strategy is very similar to hill climb, except it has one interesting twist: we add some random "bad" moves to the decision making process. We begin by making almost every move a "bad move" in the beginning, and slowly transition to only "good moves". If you've played guitar before, you know how painful it is to drop your guitar pick inside the the guitar. Removing it is a very complicated process, which resembles this algorithm. You start by shaking your guitar around wildly. You can hear the pick jumping randomly inside the guitar. Eventually, you begin to throw a few subtle swings as an attempt to send the pick closer to the opening. Once it gets close, you become extra careful and calculate every little swing, so you can get the pick out. We're going to do the same. Let's start by adding a couple of constants to our code:

```python
import random

def random_step_check():
    global r
    global dr
    return random.uniform(0, 1) < r

...

r = 0.9      # probability of making a wrong step
dr = 0.8      # rate of change of randomness probability
```

Now, we make use of these in our decision making process:

```python
for child in children[:]:
      if child.h < parent.h or random_step_check():
          parent = child

...

r *= dr
```

What is happening here is the following. `r` defines the probability of the next step being made regardless of the heuristic value. In the first iteration, this value is quite high, we will end up picking almost any step. But the probability of making such a move decreases by a factor of `dr` at the end of each iteration, making it more and more likely that only the best next step be picked. This is what the results look like:

![Image](/using-ai-to-optimize-fuselage-part-two/simulated-annealing-results.png)

`h = 0.0396759160149569`

Not so pointy this time. In fact, the result resembles modern gliders a bit more. The final drag coefficient value is slightly larger than the hill climb result.

# Evolutionary Progression

Now let's try something a little different. Genetic algorithms have been around for a while, and they've proven to be advantageous when dealing with extremely large solution spaces (such as the one we are dealing with now). I won't spend much time explaining how a genetic algorithm works; [this example](https://rednuht.org/genetic_cars_2/) does a really good job at it (as long as you're patient enough to see the results). The code for this is going to look a little different. We are going to start with a population of 100 states, each with one modification only, generated off of the slimmed down fuselage. We're going to benchmark these and pick the 10 best. Based on these 10 best, we will generate a new population of 100 states, where each state will have both parent's modifications. We can then run this for many many many generations and see what happens.

# What Could Be Done Better
