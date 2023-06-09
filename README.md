# GenesisResourcepack

## Custom Text Shader
> @PuckiSilver

By giving text a specific color, it changes how it looks:
| color | behavior |
| - | - |
| `#4e5c24` | Removes the drop shadow of the text |
| `#3b2b06` | Gives it a special red color tone (Legendary Rarity) |
| `#211905` | Gives it a special blue color tone (Mythical Rarity) |
| `#403303` | Makes the text's color an animated rainbow (Trascended Rarity) |

You can try it out using this iron sword as an example:
```hs
give @p minecraft:iron_sword{display:{Lore:[
    '{"text":"Common",     "color":"white",       "italic":false}',
    '{"text":"Uncommon",   "color":"aqua",        "italic":false}',
    '{"text":"Rare",       "color":"yellow",      "italic":false}',
    '{"text":"Epic",       "color":"light_purple","italic":false}',
    '{"text":"Legendary",  "color":"#3b2b06",     "italic":false}',
    '{"text":"Mythical",   "color":"#211905",     "italic":false}',
    '{"text":"Transcended","color":"#403303",     "italic":false}']}}
```
