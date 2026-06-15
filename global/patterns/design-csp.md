# DA — Club Santé Premium / ClubHouse

Palette ancrée sur le site CSP (clubsantepremium.com) + l'app ClubHouse :
- **Teal marque** `#00AA8D` (flash `#16C4A7`) — accent, navigation, valeur active
- **Sapin** `#022B2B` — encre, titres, graduations, aiguilles de repère
- **Crème** `#FEFAF3` (carte `#FFFFFF`, ombré `#FBF3E6`, assombri `#EDE4D3`) — fonds chauds
- **États** : vert OK `#15803D` · coral alerte `#F47D6A` · ambre attente `#D98A2B` · rouge franc `#B91C1C` (réservé « never-exceed »)

Polices : **Garaje 53 Unicase** (titres, UPPERCASE) · **Neue Montreal** (corps) · **JetBrains Mono** tabular-nums (TOUS les chiffres). Fallbacks : DM Sans / Inter / JetBrains Mono.

Esprit « instrument premium » (cockpits, dashboards) : skeuomorphisme de **précision** (cadran / aiguille / zone de seuil peinte), JAMAIS texture/glow/néon ; **une seule source de lumière, en haut** (highlight inset top + ombre douce bas) ; couleur = **signal fonctionnel** (≥ 80 % de surface neutre) ; tout indicateur graphique a son **repli chiffré** en mono.

Détail complet (palette 15 rôles + 9 composants jauge reproductibles en SVG + règles anti-kitsch) : `PennyLane/output/da-cockpit.json` et `da-cockpit-jauges.json`. Issu de 2 fan-outs UltraCode (15/06/2026), vu en vrai sur `PennyLane/public/cockpit.html`.
