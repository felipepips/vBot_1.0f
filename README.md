### Projeto abandonado, não dou suporte, não faço scripts por encomenda.

Os melhores scripts estão em:
- zPaidScripts
- zFreeScripts

Nessa pasta até que tem bastante coisa útil:
- zxVarios

Aqui eu nem olhei o que tinha dentro..
- zzAjudasDiscord

~
*
~

### Se foi útil pra você e quiser fazer uma doação: [Clique Aqui](https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL)


~
*
~

This bot is based on vBot 4.8 by Vithrax
The original repository is: https://github.com/Vithrax/vBot

Official OTCv8 Discord: https://discord.gg/yhqBE4A

This project aims to keep the bot updated, fixing some bugs and including new features, according to the needs of the community.

If you want to contribute, message me on Discord: F.Almeida#8019
(any questions and/or support, use the official v8 discord)

If you like this project, consider making a donation:
https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

ToDo:
- Create Table/Interface for global items/ids (like doors, holes, rope spots, etc)
- Fix FriendHealer shit code
- Optimize/Fix some bugs in ContainerManager

ChangeLog:
- **[General]**
  - [x] v1.0 - Added Toggle Icons for CaveBot, TargetBot & Alarms;
  - **[vLib]**
    - [x] v1.1 - New Creature Methods: 'getNextPosition' and 'getNextTile';

- **[Extras Scripts]**
  - [x] v1.0 - Re-Arranged and fixed some general bugs;
  - [x] v1.0 - Splitted in 'Basic Scripts', 'PVP Scripts' and 'CaveBot & TargetBot Settings';
  - [x] v1.0 - Fixed a common bug in 'Hold Target' and added icon;
  - [x] v1.0 - Fixed 'Check Players' common bug when no-voc;
  - [x] v1.0 - Improved 'Skin/Stake' bodies;

- **[Target]**
  - **[TargetBot]**
    - [x] v1.0 - Added Ignore List;
    - [x] v1.0 - 'Target Only Pathable Mobs' working properly;
    - [x] v1.0 - ReWork in Target Priority;
    - [x] v1.0 - Fixed Minor bugs in Looting;
    - [x] v1.1 - Add Random Move Direction in 'Avoid Waves' instead of linear walk;
  - **[AttackBot]**
    - [x] v1.0 - Fixed small bugs and UI;
    - [x] v1.0 - Added 'Old School Mode' to work on servers that doesn't allow use items in hotkeys;

- **[CaveBot]**
  - [x] v1.0 - Only some visual adjustments;
  - [x] v1.1 - Added 'CaveBot Extensions Loader' (By Lee);
    - **[NewActions]**
      - [x] v1.1 - Drop Item to Pos (By Lee);
      - [x] v1.1 - Check Level (By Lee);
    - **[SupplyCheck]**
      - [x] v1.1 - Fixed bug when creating new profiles;
      - [x] v1.1 - Fixed function addSupplyItem;
      - [x] v1.1 - New methods: 'changeProfile' and 'createProfile';
    

- **[HP]**
  - **[HealBot]**
    - [x] v1.0 - Added 'Old School Mode' to work on servers that doesn't allow use items in hotkeys;
  - **[FriendHeal]**
    - [x] v1.0 - Added 'Check RL Conditions' to make compatible with old versions;
    - [x] v1.0 - Fixed 'Custom Spell';

- **[Tools]**
    - **[Alarms]**
        - [x] v1.0 - Added 'Low Supplies' alert;
        - [x] v1.0 - Fixed 'Custom Msg' alert to work both for player and server messages;
    - **[Container Manager]**
      - [x] v1.0 - Full ReWork on Container Manager;
      - [x] v1.0 - New features: 'Auto Next Page', 'Infinite Container' and 'Open Quiver';
      - [x] v1.0 - 'Resize', 'Rename' and 'Open Minimized' container are now configurable for each entry;
      - [x] v1.0 - 'Open Container Inside' it's not for only same ID anymore;
      - [x] v1.0 - Fixed common bug that happens when character got DC/Kicked (server side container still opened, client side closed);
      - [x] v1.0 - New Feature "Full AFK" (If enabled, pause CaveBot untill all configured containers are opened);
      - [x] v1.1 - Fixed some bugs and new adjustments;
    - **[Dropper]**
      - [x] v1.0 - Added editable 'min. capacity' in Dropper; 
    - **[PlayerLists]**
      - [x] v1.1 - Fixed bug when coloring players without BotServer; 

- **[New Features]**
  - [x] v1.0 - "Auto-Party" (Original Made by Lee w/ some modifications);
  - [x] v1.0 - "Auto-Buff";
  - [x] v1.0 - "Skills HUD" (Original Made by Lee w/ some modifications);
