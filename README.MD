# Inizializzazione

```bash
systemctl --user enable --now hyprpolkitagent.service
systemctl --user enable --now waybar.service
sudo pacman -S swaync qt5-wayland qt6-wayland
```
#SDDM
Per installare un tema di sddm:
Verifica che tutte le dipendenze siano rispettate
```bash
pacman -Syu qt6-svg qt6-declarative qt5-quickcontrols2
```
Installa il tema

# Grub
1. clone this repo or download the .zip
```bash
git clone https://github.com/mino29/tokyo-night-grub.git
```
2. Change directory 
```
cd tokyo-night-grub
```
3. copy the whole tokyo-night directory grub themes
```bash
sudo cp -r tokyo-night /boot/grub/themes
```
4. edit grub file
```
sudo vim /etc/default/grub
```
change `#GRUB_THEME=` to `GRUB_THEME="/boot/grub/themes/tokyo-night/theme.txt"`
5. use magic and reboot

run this command
```
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
then reboot and voila

