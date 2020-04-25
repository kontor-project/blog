---
title: "Electric Powerplant for a Motorglider"
date: 2020-04-12T11:16:41-03:00
draft: true
---

Let's change subjects from all the AI stuff. We need to decide what the airplane will have as a powerplant, so we can estimate where the centre of mass, so we can design the wings and the tail. But before we pick a battery, motor, and propeller, we need to answer the all time question:

# Single Seat or Tandem Seats?

So far we've just been using a dummy 3d person for reference to design the fuselage. But that doesn't mean we can't make it a tandem configuration. Let's see what makes a single seat worth it:

* The design is simpler; there does not need to be an analysis on what would happen if there is and if there is no passenger. This makes mass management relatively easier
* Overall mass of the aircraft will be lower; with no possibility to carry a passenger, there is no need for a larger motor and battery
* Airframe can be built much smaller, allowing it to fit in more places. This also makes it slightly more reliable in terms of material resistance
* You will not have the chance to risk a passenger's life (cheesy but true)

And as for a tandem configuration's strengths:

* Carrying a passenger; it can get quite lonely up there
* This adds more space in the cockpit that does not necessarily need to be filled by a person. It can be used to store extra batteries or oxygen tanks for high altitude flights
* The airplane can be used for more applications such flight instruction and scenic flights
* Points above will increase interest in aircraft

It seems clear that a tandem configuration brings more rewards at the cost of more risks. So why not give it a shot? To estimate the weight of the airframe, we can look at other tandem gliders. We have the [ASK 21](https://en.wikipedia.org/wiki/Schleicher_ASK_21#Specifications_(ASK_21)) sitting comfortably at 360kg when empty, the [DG-505](https://en.wikipedia.org/wiki/Glaser-Dirks_DG-500#Specifications_(Elan_Trainer)) weighing 390kg, and the [Pipistrel Taurus](https://en.wikipedia.org/wiki/Pipistrel_Taurus#Specifications) weighing a surprising 306kg (with a motor and batteries). It would be too ambitious to expect our aircraft to weigh around the same as the Pipistrel. Using amateur fiberglass construction methods, a more realistic estimate would be around 360kg.

# Power Required to Take Off

The Pipistrel Taurus has a 40kW motor to lift it's 306kg airplane, plus a maximum of 220kg cargo. Considering how we're aiming to build a 360kg airframe, plus batteries, plus cargo, maybe we should consider a stronger motor too. Something in the vicinity of 50kW would be a good start, the details can be defined based on what is available in the market. This can give us an estimation of how heavy the batteries will be. Tesla's batteries achieve an energy density of 207W/h. This means that in order to fly at full power for 1h we need 216kg worth of batteries.

# Finding These Components

50kW brushless motors [exist](https://www.aliexpress.com/item/4000068504469.html?src=google&src=google&albch=shopping&acnt=494-037-6276&isdl=y&slnk=&plac=&mtctp=&albbt=Google_7_shopping&aff_platform=google&aff_short_key=UneMJZVf&&albagn=888888&albcp=9309943343&albag=90987094781&trgt=297309937645&crea=en4000068504469&netw=u&device=c&albpg=297309937645&albpd=en4000068504469&gclid=EAIaIQobChMIsremnKX66AIVS5yzCh3SAQPhEAkYAyABEgIdCvD_BwE&gclsrc=aw.ds) but they seem rather costly. Let's look at lower power ratings.
