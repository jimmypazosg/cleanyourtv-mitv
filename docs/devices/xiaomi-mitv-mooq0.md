# Xiaomi Mi TV (MiTV-MOOQ0) — Guía de Optimización y Launcher Limpio

Esta guía documenta la configuración probada y optimizada para el modelo **Xiaomi Mi TV (MiTV-MOOQ0)** (firmware `QTG3.200305.006.5135` / SoC MediaTek).

Permite eliminar la publicidad y el bloatware del sistema, desactivar servicios de telemetría en segundo plano y sustituir la pantalla de inicio por un launcher ultra ligero, sin anuncios y con dock personalizable.

---

## 📸 Resultados

| Pantalla de inicio limpia | Dock personalizado |
| :---: | :---: |
| ![Home limpia](screenshots/screen_home_clean.png) | ![Apple TV Style Dock](screenshots/apple_tv_custom_dock.png) |

---

## 📋 Requisitos Previos

1. **En la TV:**
   * Activar las Opciones de Desarrollador:
     * Ir a `Ajustes` > `Preferencias del dispositivo` > `Información`.
     * Bajar hasta `Número de compilación` y pulsar el botón central del mando **7 veces seguidas**.
   * Activar la depuración:
     * Ir a `Ajustes` > `Preferencias del dispositivo` > `Opciones para desarrolladores`.
     * Activar **Depuración USB** y **Depuración por red**.
   * Conocer la IP local de tu TV (ej. `192.168.1.50` en `Ajustes` > `Red e Internet` > Tu red WiFi).

2. **En tu PC (Windows / Linux / macOS):**
   * **ADB** (Android Debug Bridge) instalado y disponible en la consola.
   * **Java JDK 17+** (o Android Studio).
   * **Python 3.10+** (para los scripts de gestión en `tools/`).

---

## 🚀 Paso a Paso de Replicación

### 1. Conectar con la TV vía ADB
Abre PowerShell o tu terminal y conecta con la TV:
```powershell
adb connect 192.168.1.XX:5555
```
*(Acepta en la pantalla del televisor el mensaje de "¿Permitir depuración por USB? — Permitir siempre desde este equipo")*.

---

### 2. Copia de Seguridad Preventiva (Opcional pero Recomendado)
Antes de modificar el televisor, genera un respaldo local del estado de las aplicaciones:
```powershell
adb shell pm list packages -e > backup_packages_enabled.txt
```
*(Nota: la carpeta `backup/` del repositorio está en `.gitignore` para que tus volcados con números de serie y MAC locales nunca se compartan públicamente).*

---

### 3. Aplicar Debloat (Limpieza de Bloatware)
Ejecuta el script de deshabilitación con la lista optimizada para el modelo `MiTV-MOOQ0`:

```powershell
.\tools\disable.ps1 -TvHost 192.168.1.XX -Packages examples\xiaomi-mitv-mooq0\debloat.txt
```

**Lo que desactiva esta lista:**
* Telemetría y analíticas de Xiaomi y Google (`com.miui.tv.analytics`, `com.xiaomi.statistic`, etc.).
* Canales patrocinados y recomendaciones intrusivas (`com.mitv.tvhome.michannel`, `com.xm.webcontent`).
* Apps del sistema no utilizadas (demos, juegos de Play Games TV, etc.).
* Reproductores stock y servicios de actualización de firmware (`com.xiaomi.mitv.updateservice`) para evitar que una actualización sobreescriba los cambios.
* *(Conserva YouTube Kids y servicios de streaming estándar)*.

---

### 4. Compilar e Instalar el Launcher

El launcher incluido en este repositorio es nativo, extremadamente ligero y rápido. La configuración para este televisor incluye en el dock:
* **YouTube** (`com.google.android.youtube.tv`)
* **Disney+** (`com.disney.disneyplus`)
* **Movistar+** (`com.movistarplus.androidtv`)
* **Spotify** (`com.spotify.tv.android`)
* Mapeo del botón de entrada / remoto (`keycode 130`).

Para compilar e instalar en la TV automáticamente como pantalla de inicio predeterminada:

```powershell
.\launcher\build-and-install.ps1 -TvHost 192.168.1.XX
```

El script compilará el APK, lo enviará a la TV, lo instalará y lo asignará como el Home principal sin necesidad de root.

---

## 🔄 Cómo Revertir los Cambios (Restauración)

Si deseas volver al estado de fábrica o reactivar todas las aplicaciones del fabricante y el launcher original de Google/Xiaomi, ejecuta:

```powershell
.\examples\xiaomi-mitv-mooq0\restore.ps1 -TvHost 192.168.1.XX
```

Este script:
1. Rehabilita cada uno de los paquetes desactivados.
2. Restaura el launcher oficial (`com.google.android.tvlauncher`) como la actividad HOME predeterminada.
