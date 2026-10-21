# CleanYourTV — Xiaomi Mi TV Edition (MiTV-MOOQ0)

> **Tu Android TV más rápida, sin anuncios y con una interfaz limpia inspirada en Apple TV.**  
> Basado originalmente en el proyecto de código abierto [CleanYourTV](https://github.com/Gathin23/cleanyourtv) de [Gathin23](https://github.com/Gathin23), adaptado y optimizado específicamente para modelos **Xiaomi Mi TV** (serie `MiTV-MOOQ0`, chip MediaTek / Android TV 10).

---

## 📸 Vista Previa (Capturas Reales)

| Pantalla de inicio limpia | Dock de aplicaciones personalizadas |
| :---: | :---: |
| ![Pantalla de inicio limpia](docs/devices/xiaomi-mitv-mooq0/screenshots/screen_home_clean.png) | ![Dock personalizado](docs/devices/xiaomi-mitv-mooq0/screenshots/apple_tv_custom_dock.png) |

| Vista completa del launcher | Apps optimizadas tras debloat |
| :---: | :---: |
| ![Vista Home](docs/devices/xiaomi-mitv-mooq0/screenshots/apple_tv_home.png) | ![Post debloat](docs/devices/xiaomi-mitv-mooq0/screenshots/screen_after_debloat.png) |

---

## ⚡ ¿En qué consiste?

Los televisores con Android TV / Google TV suelen saturarse con publicidad, recomendaciones patrocinadas y servicios en segundo plano del fabricante que ralentizan el sistema.

Este proyecto permite:
1. **Eliminar Bloatware y Telemetría:** Desactiva servicios innecesarios de Xiaomi y Google mediante `adb shell pm disable-user --user 0`. **No requiere root ni cables**, no borra particiones del sistema y se puede revertir al 100%.
2. **Launcher Ultra Ligero (~405 KB):** Reemplaza el launcher cargado de publicidad por una pantalla de inicio nativa en Java/AndroidX, minimalista y fluida, diseñada para televisores con recursos limitados (1 GB / 2 GB RAM).
3. **Dock y Accesos Personalizables:** Configura tus aplicaciones preferidas en el Dock (YouTube, Disney+, Movistar+, Spotify, etc.) y asigna accesos rápidos a los botones del control remoto.

---

## 📋 Requisitos

* **En la TV:**
  * Opciones de desarrollador activas (Pulsar 7 veces sobre *Ajustes > Preferencias del dispositivo > Información > Número de compilación*).
  * Activar **Depuración USB** y **Depuración de red**.
  * Conectar la TV y el ordenador a la misma red Wi-Fi o Ethernet.
* **En el Ordenador:**
  * **Android Platform-Tools (`adb`)** en el PATH.
  * **Java JDK 17+** (o Android Studio instalado).
  * **PowerShell** (Windows) o **Bash** (macOS / Linux).

---

## 🚀 Guía de Inicio Rápido (Replicación)

### 1. Conectar a la TV vía ADB
Localiza la IP de tu TV en los ajustes de red y conéctate:

```powershell
adb connect 192.168.1.XX:5555
```
*(Confirma la autorización que aparecerá en la pantalla del televisor).*

---

### 2. Aplicar Debloat (Limpieza de aplicaciones innecesarias)

Ejecuta el script de deshabilitación con la lista probada para **Xiaomi Mi TV**:

```powershell
# En Windows (PowerShell):
.\tools\disable.ps1 -TvHost 192.168.1.XX -Packages examples\xiaomi-mitv-mooq0\debloat.txt

# En Linux / macOS (Bash):
TV_HOST=192.168.1.XX ./tools/disable.sh examples/xiaomi-mitv-mooq0/debloat.txt
```

La lista optimizada desactiva:
* Analíticas y telemetría de Xiaomi (`com.miui.tv.analytics`, `com.xiaomi.statistic`).
* Canales recomendados y apps patrocinadas (`com.mitv.tvhome.michannel`, etc.).
* Servicio de actualización de firmware (`com.xiaomi.mitv.updateservice`) para evitar que una OTA deshaga la configuración.
* *(Mantiene intactas las apps de streaming y YouTube Kids)*.

---

### 3. Compilar e Instalar el Launcher

Compila el APK e instálalo como launcher predeterminado en un solo comando:

```powershell
# En Windows (PowerShell):
.\launcher\build-and-install.ps1 -TvHost 192.168.1.XX

# En Linux / macOS (Bash):
TV_HOST=192.168.1.XX ./launcher/build-and-install.sh
```

El script detecta el SDK de Android, compila el launcher en modo *release*, lo transfiere a la TV y lo establece como la pantalla de inicio principal (`HOME`).

---

## ⚙️ Personalización del Launcher

Puedes personalizar las aplicaciones del dock y las teclas del control remoto antes de compilar editando [`launcher/app/src/main/res/values/config.xml`](launcher/app/src/main/res/values/config.xml):

```xml
<!-- Apps ancladas en la fila del dock inferior -->
<string-array name="dock_apps">
    <item>com.google.android.youtube.tv</item>
    <item>com.disney.disneyplus</item>
    <item>com.movistarplus.androidtv</item>
    <item>com.spotify.tv.android</item>
</string-array>

<!-- Keycodes especiales del control remoto (ej. tecla 130) -->
<integer-array name="input_key_keycodes">
    <item>130</item>
</integer-array>
```

---

## 🔄 Restauración (Deshacer Cambios)

Si deseas restaurar el televisor a su estado original (rehabilitar todas las aplicaciones del fabricante y volver al launcher stock de Google/Xiaomi):

```powershell
.\examples\xiaomi-mitv-mooq0\restore.ps1 -TvHost 192.168.1.XX
```

El script rehabilita todos los paquetes desactivados y reactiva el launcher original (`com.google.android.tvlauncher`).

---

## 📖 Documentación Detallada

* [Guía técnica específica de Xiaomi Mi TV (MiTV-MOOQ0)](docs/devices/xiaomi-mitv-mooq0.md)
* [Solución de problemas (Troubleshooting)](docs/TROUBLESHOOTING.md)
* [Mapeo de botones del mando a distancia](docs/REMOTE.md)

---

## 🤝 Créditos y Atribución

Este proyecto utiliza como base el software de código abierto [CleanYourTV](https://github.com/Gathin23/cleanyourtv), creado por [Gathin23](https://github.com/Gathin23). 

Agradecimientos al autor original y a la comunidad por el desarrollo del launcher base y la infraestructura de scripts ADB.

## 📄 Licencia

Este repositorio se distribuye bajo la licencia **MIT** (ver [`LICENSE`](LICENSE)).  
La fuente tipográfica *Outfit* está protegida por la licencia SIL Open Font License (ver `launcher/FONT-LICENSE-OFL.txt`).
