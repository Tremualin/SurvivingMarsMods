# Changelog for Incubator
## v2.0.1 04/10/2021 1:11:32 PM
#### Changed
- OnMsg.ColonistBorn(colonist, event)

#### Fixed Issues
- getting nil index error when trait group is missing

--------------------------------------------------------
## v2.0 04/03/2021 5:18:06 PM
#### Changed
- License file and Type from MIT to GPL v3
- StringIdBase changed from 1776150000 to 17764704600
- various nil checks
- function RemoveSpecialization(colonist) -- improved logic
- updated proper StringIdBase numbers in buttons
- INCControlVer = "v2.2"
- modified OnMsg.ColonistBorn for androids fix traits

#### Added
- readme.md
- initRan variable to g_Incubator
- mod_Enabled variable to g_Incubator
- INC_3ModConfig.lua file and associated options
- g_Incubator.mod_Enabled to panels
- g_Incubator.mod_Enabled tof re-writen classes as short circuit
- handles to threads in OnMsg.ColonistBorn(colonist, event)
- fixAndroidPos and fixAndroidNeg vars to g_Incubator
- function INCaddTraits() for ading in new trait
- Trait Phoenix for tracking purposes
- check to INCFindIncubationLoc() to make sure dome/home powered on and not quarantined


--------------------------------------------------------
## 1.12.5 07/23/2019 7:35:09 PM
#### Changed
- INCrenameColonists()
  - added check for table
- INCFindIncubationLoc()
  - added in code to also take into consideration OpenCity

#### Fixed Issues
- throwing errors when names of colonists changed and no longer a table
- opencity domes would not spawn children since they would never be chosen for destination.

--------------------------------------------------------
## v1.12.4 06/08/2019 3:15:40 PM
#### Changed
- INCGetStatusText(dome)

#### Fixed Issues
- error in clone vat text, wrong variable

--------------------------------------------------------
## v1.12.3 05/20/2019 5:13:13 AM
#### Changed
- CloningVats:BuildingUpdate(dt)

#### Fixed Issues
- Cloning vats when INC was off was not updating the building.  Forgot self in the function.

--------------------------------------------------------
## v1.12.2 05/10/2019 12:31:09 AM
#### Changed
- INCrenameColonists()

#### Removed
- removed line check 120 since it was borking names table and used direct check if statement

#### Fixed Issues
- Names not properly being determined, changed function to use NameUnit()

--------------------------------------------------------
## v1.12.1 05/02/2019 1:07:26 AM
#### Changed
- Line 120 added check for gender, if not male or female then default male.

#### Fixed Issues
- Biorobots do not have gender caussing error to be thrown on line 120 when checcking names against genders

--------------------------------------------------------
## 1.12.0 04/23/2019 10:12:42 PM
#### Changed
- Added cloned colonists to summary

#### Added
- New button to cloaning vats
- INCGetButtonStatusText()
- function CloningVats:BuildingUpdate(dt)

--------------------------------------------------------
## v1.11.1 12/25/2018 7:04:39 PM
#### Changed
- Dome:SpawnChild()

#### Added
- function INCrenameColonists() to run on LoadGame() to check each time game loads

#### Fixed Issues
- incorrect first names give when Dome:SpawnChild() called

--------------------------------------------------------
## v1.11.0 12/23/2018 10:16:17 PM
#### Changed
- XTemplate for Incubators settings to change rollover text
- renamed code files

#### Added
- more status messages to rollover text for INC button section
- function INCGetStatusText(dome)

--------------------------------------------------------
## v1.10.2 12/14/2018 9:17:03 PM
#### Changed
- RemoveSpecialization()
  - Included colonist in Msg("NewSpecialist", colonist) due to changes in Kuiper Patch

--------------------------------------------------------
## v1.10.1 12/09/2018 9:02:09 PM
#### Changed
- RemoveSpecialization(colonist)

#### Fixed Issues
- fixed issue with using self instead of colonist line 102 in RemoveSpecialization(colonist)

--------------------------------------------------------
## v1.10.0 12/06/2018 10:03:36 PM
#### Added
- code for OnMsg.ColonistBorn to fix project phoenix
- RemoveSpecialization(colonist)

#### Fixed Issues
- fixed bad project phoenix code

--------------------------------------------------------
## v1.9.1 12/05/2018 1:16:17 AM
#### Changed
- Dome:SpawnChild()  added "martianborn"
  - local colonist = GenerateColonistData(self.city, "Child", "martianborn")
- .gitignore
- copied preview image to root

#### Added
- ignore_files to metadata

#### Fixed Issues
- incubator domes did not always spawn martiandomes.  Randomly they spawned earth colonists due to flaw
in copied github code from Dome:SpawnChild.  GenerateColonistData did not have "martianborn"
reported to devs to fix docs.

--------------------------------------------------------
## v1.9.0 11/01/2018 1:31:46 AM
- Gagarin Tested

#### Added
- .gitignore file
- Id field to template for easy tracking
--------------------------------------------------------
### Legacy Changelog
ChangeLog:
v1.8 Sept 27th, 2018
- Sagan update

v1.7 Aug 30th, 2018
- Added comfort boost to all domes - see notes.

v1.6 Aug 17th, 2018
- Fixed davinci path issue.

v1.5.1 Aug 14th, 2018
- Fixed retrofix button code

v1.5 Aug 8th, 2018
-Davinci Patch Fixes
-First born is a celebrity
-Code Optimizations

v1.4 Aug 6th, 2018
-Davinci Patch Fixes
-Code Optimizations

v1.3 Aug 1st, 2018
- Code optimizations

v1.2 July 29th, 2018
- Code optimizations and sound effects.

v1.1 July 13th, 2018
- Moved ip Icons to top.
- Optimized Code

v1.0
July 12th, 2018
Initial Upload
