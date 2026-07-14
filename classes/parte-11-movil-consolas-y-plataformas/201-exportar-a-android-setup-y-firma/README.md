# Clase 201 — Exportar a Android: setup y firma

> Parte: **11 — Móvil, consolas y plataformas** · Fuente: *Documentación de Godot 4 (Exporting for Android) · developer.android.com*
> ⏱️ Duración estimada: **90 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Exportar a Android es el primer salto de "corre en mi PC" a "corre en un teléfono real", y tiene más piezas de las que parece: plantillas de exportación, el Android SDK y un JDK, una **keystore** para firmar, y la decisión entre **APK** y **AAB**. Sin firma válida, Android se niega a instalar el paquete; sin las plantillas, Godot no puede construirlo.

En esta clase configuramos el entorno de exportación de Android en Godot 4, generamos una keystore de debug y otra de release con `keytool`, exportamos un **APK firmado** y lo instalamos en un dispositivo por `adb`. Entenderás cuándo usar APK (pruebas e instalación directa) y cuándo AAB (publicación en Google Play), y por qué la firma de release debe guardarse con cuidado.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Instalar las plantillas de exportación y configurar el Android SDK/JDK en Godot 4.
2. Generar keystores de debug y release con `keytool`.
3. Configurar un preset de exportación de Android con su firma.
4. Distinguir APK de AAB y elegir el formato según el objetivo.
5. Instalar y depurar un APK en un dispositivo físico con `adb`.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | Plantillas de exportación | Sin ellas Godot no genera el build. |
| 2 | Android SDK y JDK | Herramientas que compilan el paquete. |
| 3 | Keystore de debug | Firma automática para pruebas locales. |
| 4 | Keystore de release | Identidad estable para publicar. |
| 5 | Firma con `apksigner` | Valida que el APK no fue alterado. |
| 6 | APK vs AAB | Instalación directa vs publicación en Play. |
| 7 | Gradle build | Build personalizado con plugins nativos. |
| 8 | Instalación con `adb` | Probar en hardware real y ver logs. |

## 📖 Definiciones y características

- **Plantilla de exportación**: binario base de Godot para cada plataforma. Clave: se instala desde Editor → Manage Export Templates, versión idéntica al editor.
- **Android SDK**: conjunto de herramientas de compilación de Android. Clave: Godot pide su ruta y la del JDK en Editor Settings.
- **JDK**: Java Development Kit (OpenJDK 17 recomendado). Clave: necesario para `keytool` y para el build de Gradle.
- **Keystore**: archivo `.keystore`/`.jks` con la clave privada que firma la app. Clave: define la identidad de tu app; si la pierdes no puedes actualizar en Play.
- **Firma de debug**: keystore genérica solo para pruebas. Clave: Godot puede generarla automáticamente.
- **`apksigner`**: herramienta del SDK que firma y verifica APKs. Clave: comprueba integridad del paquete.
- **APK**: paquete instalable directo en un dispositivo. Clave: ideal para pruebas y distribución fuera de Play.
- **AAB (Android App Bundle)**: formato que Google Play requiere para publicar. Clave: Play genera APKs optimizados por dispositivo desde el AAB.

## 🧰 Herramientas y preparación

Necesitas Godot 4 (versión estándar; para builds con plugins nativos también sirve), el **Android SDK** con las command-line tools, un **JDK 17** (OpenJDK) y un dispositivo Android con **Depuración USB** activada en Opciones de desarrollador. La forma más simple de obtener el SDK es instalar Android Studio, que trae SDK, plataformas y `adb`. Godot necesita las rutas del SDK y del `keytool`/JDK en Editor → Editor Settings → Export → Android.

Sigue la guía oficial de Godot para Android en <https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html> y la referencia de `adb` en <https://developer.android.com/tools/adb>. Ten a mano una terminal donde `adb` y `keytool` estén en el PATH.

## 🧪 Laboratorio guiado

Configuraremos el export de Android, crearemos una keystore, exportaremos un APK firmado y lo instalaremos por `adb`.

1. Instala las **plantillas**: en Godot ve a **Editor → Manage Export Templates → Download and Install**. Deben coincidir con tu versión exacta del editor.

2. Configura rutas en **Editor → Editor Settings → Export → Android**: indica **Android SDK Path** (carpeta del SDK) y verifica **Java SDK Path** si Godot no lo detecta. Pulsa el botón de comprobación; debe reportar OK.

3. Genera una **keystore de debug** (una sola vez) con `keytool`:

```bash
keytool -keyalg RSA -genkeypair -alias androiddebugkey \
  -keypass android -keystore debug.keystore -storepass android \
  -dname "CN=Android Debug,O=Android,C=US" -validity 9999
```

4. En **Editor Settings → Export → Android** apunta **Debug Keystore** a ese `debug.keystore` (user/password `androiddebugkey`/`android`). Así las exportaciones de debug quedan firmadas automáticamente.

5. Genera una **keystore de release** (guárdala fuera del repo y respáldala):

```bash
keytool -keyalg RSA -genkeypair -alias mijuego \
  -keystore release.keystore -storepass CAMBIA_ESTO \
  -keypass CAMBIA_ESTO -validity 9999 \
  -dname "CN=Mi Estudio,O=Mi Estudio,C=CL"
```

6. Crea el **preset de exportación**: **Project → Export → Add → Android**. En la sección **Keystore**, para Release indica el `release.keystore`, el alias `mijuego` y las contraseñas. Marca el formato: **APK** para instalar directo, **AAB** para Google Play.

7. Exporta el APK: en el diálogo de Export pulsa **Export Project…**, elige salida `mijuego.apk`, deja **Export With Debug** desmarcado para una build de release firmada con tu keystore.

8. Conecta el teléfono, verifica que `adb` lo ve y **instálalo**:

```bash
adb devices
adb install -r mijuego.apk
adb logcat -s godot     # ver logs del juego en tiempo real
```

9. Alternativa desde el editor: con el dispositivo conectado, el botón **One-click deploy** (icono de Android en la barra superior) exporta e instala en debug de un tirón, útil para iterar.

Ya tienes un APK firmado corriendo en hardware real y puedes leer sus logs por `logcat`.

## ✍️ Ejercicios

1. Exporta la misma build como **AAB** y compara el tamaño del archivo con el APK.
2. Cambia el **nombre de paquete** (`org.tuestudio.mijuego`) y reinstala; observa que se instala como app separada.
3. Sube la **versión** (versionCode y versionName) en el preset y reinstala con `adb install -r`.
4. Usa `adb logcat -s godot` para capturar un `print()` de tu juego corriendo en el móvil.
5. Genera un icono adaptativo y configúralo en el preset de exportación.
6. Documenta en un README dónde guardas la keystore de release y por qué no va al repositorio.

## 📝 Reto verificable

Exporta tu juego a un **APK de release firmado con tu propia keystore** (no la de debug), instálalo en un dispositivo Android físico por `adb install -r` y demuestra que arranca capturando al menos una línea de log del juego con `adb logcat -s godot`.

**Criterio de aceptación**: el APK está firmado con la keystore de release (verificable con `apksigner verify --print-certs mijuego.apk`), `adb install -r` termina con "Success", la app abre en el dispositivo y el `logcat` muestra salida del juego. La keystore de release queda fuera del control de versiones.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| "No export template found" | Faltan las plantillas o no coinciden con la versión. Reinstálalas desde Manage Export Templates. |
| "Invalid Android SDK path" | Ruta del SDK mal configurada. Corrígela en Editor Settings → Export → Android. |
| `adb: no devices/emulators found` | Falta Depuración USB o el driver. Actívala y acepta el diálogo de confianza en el teléfono. |
| "INSTALL_FAILED_UPDATE_INCOMPATIBLE" | Firma distinta a la ya instalada. Desinstala la app previa o usa la misma keystore. |
| Google Play rechaza el APK | Play exige **AAB**. Exporta en formato AAB para publicar. |
| App instala pero no abre | Renderer o arquitectura incompatible. Usa renderer Mobile y verifica arquitecturas (arm64) en el preset. |

## ❓ Preguntas frecuentes

**❓ ¿APK o AAB?** APK para probar e instalar directo (o distribuir fuera de Play). AAB es obligatorio para publicar en Google Play, que genera desde él APKs optimizados por dispositivo.

**❓ ¿Qué pasa si pierdo la keystore de release?** No podrás publicar actualizaciones firmadas con la misma identidad en Play. Respáldala en un lugar seguro y anota sus contraseñas; es irremplazable salvo esquemas de recuperación de Play.

**❓ ¿Necesito Android Studio?** No estrictamente, pero es la vía más cómoda para instalar SDK, plataformas y `adb`. También puedes instalar solo las command-line tools del SDK.

**❓ ¿Cuándo necesito el "custom Gradle build"?** Cuando integras plugins nativos de Android (por ejemplo AdMob o billing, clase 206). Activa **Use Gradle Build** en el preset e instala la plantilla de build de Android.

## 🔗 Referencias

- Godot Docs — Exporting for Android: <https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html>
- Godot Docs — Android custom build and Gradle: <https://docs.godotengine.org/en/stable/tutorials/export/android_gradle_build.html>
- Android — adb (Android Debug Bridge): <https://developer.android.com/tools/adb>
- Android — Sign your app (apksigner, keystore): <https://developer.android.com/studio/publish/app-signing>

## ➡️ Siguiente clase

[Clase 202 - Exportar a iOS: setup y provisioning](../202-exportar-a-ios-setup-y-provisioning/README.md)
