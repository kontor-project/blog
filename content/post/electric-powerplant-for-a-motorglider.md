---
title: "Electric Powerplant for a Motorglider"
date: 2020-04-12T11:16:41-03:00
draft: false
---

Let's change subjects from all the AI stuff. We need to decide what the airplane will have as a powerplant, so we can estimate where the centre of mass will be, so we can design the wings and the tail. But before we pick a battery, motor, and propeller, we need to answer the all time question:

# Single Seat or Tandem Seats?

So far we've just been using a dummy 3d person for reference to design the fuselage. But that doesn't mean we can't make it a tandem configuration. Let's see what makes a single seat worth it:

* The design is simpler; there does not need to be an analysis on what would happen if there is and if there is no passenger. This makes mass management relatively easier
* Overall mass of the aircraft will be lower; with no possibility to carry a passenger, there is no need for a larger motor and battery
* Airframe can be built much smaller, allowing it to fit in more places. This also makes it slightly more reliable in terms of material resistance
* You will not have the chance to risk a passenger's life (cheesy but true)
* There are more small motors available than large ones. This means there will be more options to chose from when picking powerplants

And as for a tandem configuration's strengths:

* Carrying a passenger; it can get quite lonely up there
* This adds more space in the cockpit that does not necessarily need to be filled by a person. It can be used to store extra batteries or oxygen tanks for high altitude flights
* The airplane can be used for more applications such flight instruction and scenic flights
* Increased range when flying solo
* Points above will increase interest in aircraft, thus potentially making it more economically interesting to manufacture more than a prototype

It seems clear that a tandem configuration brings more rewards at the cost of more risks. So why not give it a shot?

# How Heavy Will The Airframe Be?

I don't know, let's find out. To estimate the weight of the airframe, we can look at other tandem gliders. We have the [ASK 21](https://en.wikipedia.org/wiki/Schleicher_ASK_21#Specifications_(ASK_21)) sitting comfortably at 360kg when empty, the [DG-505](https://en.wikipedia.org/wiki/Glaser-Dirks_DG-500#Specifications_(Elan_Trainer)) weighing 390kg, and the [Pipistrel Taurus](https://en.wikipedia.org/wiki/Pipistrel_Taurus#Specifications) weighing a surprising 306kg (with a motor and batteries). It would be too ambitious to expect our aircraft to weigh around the same as the Pipistrel. There is also the [Pipistrel ALPHA Electro](https://www.pipistrel-aircraft.com/aircraft/electric-flight/alpha-electro/) (not a glider, but still an impressive electric aircraft), weighing 365kg, batteries included, with a 60min autonomy. Using amateur fiberglass construction methods, a realistic airframe weight estimate would be between 300kg to 360kg.

# Power Required to Take Off

The nerdiest way to determine the minimum takeoff power is to calculate two things:

1. The [wing loading](https://en.wikipedia.org/wiki/Wing_loading), which is calculated by dividing the wing area by the weight of the aircraft. We don't have the wings designed yet, nor do we know the mass of the batteries yet
2. The [thrust to weight ratio](https://en.wikipedia.org/wiki/Thrust-to-weight_ratio), which is calculated in a variety of different ways, that demand values we also don't have defined yet. But ideally speaking, we are interested in a thrust to weight ratio of at least 1/4 in ideal conditions.

Since we have almost nothing determined, it is hard to determine the exact minimum power needed. So let's look at similar projects, and draw numbers from those. The Pipistrel Taurus has a 40kW motor to lift it's 306kg airplane, plus a maximum of 220kg cargo. The Pipistrel ALPHA Electro has a 60kW motor with at 368kg and a maximum load of 182kg. Considering how we're aiming to build a 300-360kg airframe, plus batteries, plus cargo, it is clear we will need at least a 40kW motor. However, ideally we would need something slightly more powerful; maybe 50kW. This can give us an estimation of how heavy the batteries will be. Tesla's batteries achieve an energy density of [207W/h](https://www.extremetech.com/extreme/285666-did-tesla-buy-maxwell-for-its-ultracapacitors-or-higher-density-batteries). However, Tesla does not sell batteries to aircraft manufacturers as far as I know (maybe I should e-mail them). Most batteries in the market have an energy density closer to 100W/h. This means that in order to fly at full power for 2h using a 50kW motor we need 500kg worth of batteries. That is a lot, even if flying at full throttle the entire time is impossible. It seems we will have to modify the minimum requirements of the entire project, and reduce the minimum flight time to something more realistic. Let's see what the market offers before deciding what the minimum flight time should be.

# Finding These Components

50kW brushless motors [exist](https://www.aliexpress.com/item/4000068504469.html?src=google&src=google&albch=shopping&acnt=494-037-6276&isdl=y&slnk=&plac=&mtctp=&albbt=Google_7_shopping&aff_platform=google&aff_short_key=UneMJZVf&&albagn=888888&albcp=9309943343&albag=90987094781&trgt=297309937645&crea=en4000068504469&netw=u&device=c&albpg=297309937645&albpd=en4000068504469&gclid=EAIaIQobChMIsremnKX66AIVS5yzCh3SAQPhEAkYAyABEgIdCvD_BwE&gclsrc=aw.ds) but they seem a bit underused. It could be because there are not too many electric airplanes in the sky, which is not entirely their fault. But it is a bit scary, they have no track record. However, Pipistrel kindly offers a ["plug-n-play" electric propulsion system](https://www.pipistrel-usa.com/electric-propulsion/), which also happens to be the system the Pipistrel ALPHA Electro is based on. This one claims to have been tested by NASA (which is a bit overkill for our purposes). This motor has a slightly lower power output of 40kW and their largest battery has offers 9.7kW/h. At full throttle we can expect 0.24h flight time. This is not ideal, but let's dissect the spec sheet a little more. The kit also provides an optimized propeller, which when coupled with the rest of the kit, has a maximum static thrust of 143kg in ISA conditions. A Cessna 172 are known to have a thrust to weight ratio somewhere around 0.4 or 0.3 (highly dependent on weather conditions). With a maximum thrust to weight ration of around 0.35, we land somewhere close to the performance of a C172 (disregarding passengers). There are two problems with Pipistrel's kit. First, the cannot be operated in temperatures below 5°C, which in Canada doesn't happen too often, eh. The second is the price of this kit. After poking around the website, I found the [cost spreadsheet](https://www.pipistrel-prices.com/configurator/configure/647/), (where it seems there is an option to upgrade the motor to 60kW). The kit is priced at 16,100 euros (before taxes). Essentially, we are trading time for money here. All the testing to ensure we will have enough power to fly is already done for us, which we would *absolutely* have to conduct if we used one of the Aliexpress motors. This is great if we have don't have a facility to test this (which we don't) and have money (which we also don't). For the sake of making a decision, we will opt of Pipistrel's kit. It is the lesser of the two evils: we can be sure of the product's quality (it was tested by NASA, and those guys know how to make things fly), and it is a known cost. What I mean by that is, if we decide to opt for a motor from Aliexpress, chances are that we won't just buy one. We might end up buying a few until we find the correct one. The same applies for a propeller and a battery pack. Pipistrel has likely already explored various suppliers in search of a powerplant (as we are now doing). This is not an immutable decision, as the construction and design of the airframe is mostly independent of the powerplant. This also sets a few other expectations. For one, the 2h flight time at maximum power we were dreaming of, now seems unrealistic. Second, we now have an idea of how much the aircraft will cost to design; at least 16,100 euros.

# Can I Use Bondo To Fix Rust On My Bicycle?

I found this old rusty bicycle in a yard the other day, and decided to give it a second chance. I had to split the chain off because of how rusty it was. It still has a bull horn shaped handlebar, common in the 50s and 60s. I took it all apart, and sanded it down to bare metal (turns out it's made of steel). On some places the rust seems to have corroded so much steel away, that there are holes in the frame. It's not so bad that it won't hold my weight yet, but something should be done to repair that. I went to Canadian Tire (please sponsor me, this project is getting expensive), got some body filler, and got to work. Turns out that if you mix the filler with the hardening agent, you have to work fast before it becomes too hard. Also, avoid leaving it on direct sunlight, that seems to have solidified my first batch too soon. I applied the filler to the cleaned out rust spots, waited a while to solidify, and sanded it down. Now I'm going to paint the frame, order a new chain, new tires, and maybe a 2 stroke engine to make it look like a 20s board tracker. So, yes, you can use bondo to fix rust on your bicycle.

# What Did We Learn?

This puts things into perspective. With Pipistrel's kit, we are looking at the following:

* The project now costs at least 16,100 euros plus taxes and shipping
* We can no longer fly below 5°C (unless we build a battery heater)
* The maximum flight time at full power will come close to 15min (likely extendable to 45min of cruise time)
* With a standard battery pack of 4 Pipistrel batteries, we will add around 100kg to the rear end of the cockpit
* Don't leave body filler in the sunlight

Based on these points, we can also plan the next few steps:

* We can plan to extend the fuselage, and calculate an approximation of the centre of mass
* We can explore funding options for the project

#### Thanks!

See my [previous](/post/using-ai-to-optimize-a-fuselage-part-two/) and my [next](composite-aircraft-building-materials-and-methods) post 🙂

-by Eduardo"
