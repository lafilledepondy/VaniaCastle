<div style="text-align:right">
    23/04/2025
</div>

# Vaniacastle

## Histoire

_« VaniaCastle »_

30 Avril. Nuit. L'air est empli d'une énergie surnaturelle. La cause : La maudite **Nuit de Walpurgis** se tient en se moment, nuit de vent mauvais, de flammes vacillantes, et surtout, où d'oubliés accords ressurgissent des ténèbres où ils furent enfouis. Les ombres s'étirent sous ce pâle clair de lune tandis que sorcières, âmes damnées, et rites interdits entament leur funeste ballet.

Une jeune femme, le coeur embrasé par la vengeance, se tient au carrefour du destin. Ghoulifiée par un puissant vampire, elle n'a que peu de temps pour se défaire de sa malédiction. Une seule solution : abattre lui qui l'eut maudite.

Guidée par la carte d'un oracle anonyme, c'est à travers des ruines oubliées, de dangereux labyrinthes, et de maudites forêts qu'elle s'aventura, avant d'enfin atteindre la demeure de son némésis en cette nuit fatidique.
Ce dernier sais se montrer méfiant, ainsi, c'est dans une chambre scellée de 4 clés magique qu'il se terre.
Chacune de ces clés est protégée par un terrible gardien, chacune dans une section différente de son imposante demeure :

- **La clef azuée** - Au sommet du donjon, là ou sont chantés les secrets du vent
- **La clef d'améthyste** - Perdue entre rêves et cauchemars, dans le quartier des domestiques
- **La clef sanglante** - Tombée dans les entrailles du palais, où brûle une insatiable haine
- **La clef d'or'** - Conservée dans le geôles de l'antres, enterrée dans l'infini du temps

D'une motivation de diamant, sa quête est plus qu'une simple vengeance, c'est une lutte deséspérée pour sa liberté.
Cette nuit, la roue du destin tourne plus que jamais : Sa malédiction sera levée, où elle finira comme toutes les autres avant elle : une âme damnée, perdue dans la nuit.

## Installation

### Prérequis

- Un ordinateur, de toute évidence
- OCaml 4.14.1
- Dune
- Python3
- jsOfOcaml

### Installation

1. Clone :

```
git clone https://github.com/PrettyPinkFlower/ProjetPFA.git
```

2. Naviguer jusqu'au répertoire project/game :

```
cd ProjetPFA/game
```

3. Lancement :

_Note: le jeu tourne pas sur SDL_

- Pour SDL (**TRIGGER WARNING : Images Clignotantes**) :

  ```
  dune build @sdl
  ./prog/game_sdl.exe
  ```

- Pour éxécuter sur navigateur :
  Dans votre terminal :
  ```
  dune clean && dune build
  python3 -m http.server
  ```

  Puis dans votre navigateur (en cas de problème, basculer sur firefox) :
  http://localhost:8000/

## Manuel

### Règles

Quand vos points de vie (barre rouge en haut à gauche) tombent à 0, c'est le game over !
Si vous parvenez à braver les dangers des 2 salles puis à vaincre le boss de ce premier niveau, Cyclotor l'Affreux, c'est gagné !
La barre bleue en dessous de vos points de vie est la barre de mana, tant qu'elle n'est pas vide, vous pouvez tirer des boules de feu.
Pour vous préparer à votre épique duel contre Cyclotor, les ennemis, à leur mort, vous donneront l'un des 3 objets suivants :
    - Calice de sang : Régénère 10 points de vie (pas de limite)
    - Orbe de mana : Régénère 10 points de mana (pas de limite)
    - Croix inversée : Augmente votre attaque de 2 points (pas de limite)

### Controles

_Définis dans `src/core/input.ml file`_

Mouvement
| **Clé** | **Action** |
| ------: | ----------------------------|
| `z` | Saut |
| `d` | Aller à droite |
| `q` | Aller à gauche |

Combat
| **Clé** | **Action** |
| ------: | ----------------------------|
| `espace` | Coup d'épée |
| `e` | Boule de feu |

État du jeu
| **Key** | **Action** |
| ------: | ------------------------------------------------------- |
| `r` | Recharge la zone courante (debugging) |
| `s` | Pause le jeu |
| `p` | Affichage d'informations relatives au personnage |
| `Enter`| Sur l'écran titre, démarre le jeu. Ne fait rien ailleurs |

## Autrices

- Èvelyne CHEVAILLIER
- Gayathiri RAVENDIRANE
