# Clase 208 — Publicar en las tiendas móviles

> Parte: **11 — Móvil, consolas y plataformas** · Fuente: *Documentación de Google Play Console y App Store Connect*
> ⏱️ Duración estimada: **85 min** · Nivel: **Intermedio**

---

## 🎯 Objetivo

Recorrer el proceso real de publicación de un juego de Godot 4 en las dos tiendas móviles: **Google Play** (mediante **Play Console**) y **App Store** (mediante **App Store Connect**). Publicar no es solo subir un archivo: implica preparar la **ficha de la tienda** (capturas, descripción, iconos, clasificación por edad), generar el **paquete correcto** (un **AAB** firmado en Android, un IPA en iOS), pasar la **revisión** de la plataforma y decidir la estrategia de **lanzamiento por fases**.

Al terminar tendrás claro el flujo completo de Android de principio a fin —desde el AAB firmado hasta el despliegue gradual— y conocerás las particularidades de la revisión de Apple. Dejarás preparada una ficha y un paquete listo para subir, junto con una checklist de publicación reutilizable.

## 📚 Resultados de aprendizaje

Al finalizar, el alumno podrá:

1. Diferenciar Play Console de App Store Connect y sus flujos de publicación.
2. Generar un **AAB firmado** desde Godot 4 con un keystore de release propio.
3. Preparar una ficha de tienda completa: capturas, descripción, icono y clasificación de edad.
4. Explicar la revisión de cada tienda y por qué Apple suele ser más estricta.
5. Configurar un **lanzamiento por fases** (staged rollout) para reducir riesgo.

## 🗺️ Temas

| # | Tema | Por qué importa |
|---|------|-----------------|
| 1 | AAB vs APK | Play exige AAB para apps nuevas. |
| 2 | Firma de release y keystore | Sin firma correcta la tienda rechaza el paquete. |
| 3 | Ficha de la tienda | Es lo que convierte una visita en una descarga. |
| 4 | Clasificación de edad | Obligatoria; un cuestionario define la etiqueta. |
| 5 | Revisión de plataforma | Puede tardar horas o días y rechazar el envío. |
| 6 | Canales de prueba | Testing interno/cerrado antes de producción. |
| 7 | Lanzamiento por fases | Despliega al 5-10% y observa antes del 100%. |
| 8 | Particularidades de Apple | Requiere Mac, Xcode y revisión humana estricta. |

## 📖 Definiciones y características

- **AAB (Android App Bundle)**: formato de publicación de Android; Google genera los APK por dispositivo. Clave: obligatorio para apps nuevas en Play.
- **APK**: paquete instalable directo; útil para pruebas laterales, no para publicar apps nuevas. Clave: sirve para repartir builds fuera de la tienda.
- **Keystore de release**: archivo con la clave que firma tu app de forma permanente. Clave: si lo pierdes, no puedes actualizar la app.
- **Ficha de la tienda (store listing)**: textos, capturas, icono y vídeo que ve el usuario. Clave: primer factor de conversión.
- **Clasificación de edad**: etiqueta (PEGI, ESRB, IARC) obtenida por cuestionario. Clave: obligatoria para publicar.
- **Revisión (review)**: comprobación de la tienda antes de aprobar. Clave: puede rechazar por políticas, privacidad o contenido.
- **Staged rollout**: liberar la versión a un porcentaje creciente de usuarios. Clave: permite frenar si aparecen fallos.
- **App Store Connect**: panel de Apple para gestionar apps iOS. Clave: requiere macOS y Xcode para subir el build.
- **Play App Signing**: servicio de Google que custodia la clave de firma final. Clave: te protege si pierdes tu clave de subida.
- **versionCode / versionName**: número interno incremental y nombre visible de la versión. Clave: cada release debe subir el `versionCode`.

## 🧰 Herramientas y preparación

Para Android necesitas **Godot 4.x**, el **Android SDK/JDK** configurados en el editor (Editor Settings → Export → Android) y un **keystore de release** propio generado con `keytool`. Para iOS necesitas un **Mac con Xcode** y una cuenta del **Apple Developer Program**. Ten preparadas las capturas en las resoluciones que exige cada tienda y un icono de alta resolución.

Documentación oficial: exportar a Android en Godot <https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html>, publicar en Play Console <https://support.google.com/googleplay/android-developer> y App Store Connect <https://developer.apple.com/help/app-store-connect/>.

## 🧪 Laboratorio guiado

Prepararemos la ficha y el **AAB firmado** de Android, y dejaremos una checklist de publicación.

1. Genera un **keystore de release** (una sola vez, guárdalo bien):

```bash
keytool -genkeypair -v -keystore release.keystore -alias juego \
  -keyalg RSA -keysize 2048 -validity 10000
```

2. En Godot: **Project → Export → Add… → Android**. En el preset, sección **Keystore**, indica la ruta de `release.keystore`, el alias y las contraseñas en los campos **Release**.

3. En el mismo preset, activa **Export Format: AAB** (Android App Bundle) y revisa el **Package/Unique Name** (por ejemplo `com.miestudio.miplataformas`), la versión (`versionCode` y `versionName`) y los permisos mínimos.

4. Pulsa **Export Project…**, elige nombre `miplataformas-release.aab`. Godot generará el bundle firmado con tu clave de release.

5. En **Play Console**, crea la app y rellena la **ficha principal**: título, descripción breve y completa, icono (512×512), gráfico destacado y capturas de teléfono (mínimo 2, formato correcto).

6. Completa el **cuestionario de clasificación de contenido** para obtener la etiqueta de edad (IARC), y la sección de **privacidad y seguridad de datos** (obligatoria).

7. Sube el AAB a un **canal de prueba interna** primero (**Testing → Internal testing → Create release**). Añade tu correo como probador y valida la instalación desde el enlace.

8. Cuando esté verificado, promociona a **Production** con un **staged rollout** al 10%. Desde ahí podrás subir el porcentaje o pausar si aparecen errores.

9. Guarda esta **checklist de publicación** en el repo:

```text
[ ] AAB firmado con keystore de release (no debug)
[ ] versionCode incrementado respecto a la versión anterior
[ ] Ficha: título, descripciones, icono, gráfico destacado, capturas
[ ] Clasificación de edad completada
[ ] Sección de privacidad y seguridad de datos completada
[ ] Política de privacidad enlazada (si recopilas datos)
[ ] Probado en canal interno antes de producción
[ ] Rollout por fases configurado
```

Para iOS el flujo es análogo pero se exporta desde Godot a un proyecto Xcode, se archiva y se sube con Xcode/Transporter a App Store Connect, donde pasa la revisión humana de Apple.

## ✍️ Ejercicios

1. Genera un AAB de release y verifica con `bundletool` que está firmado con tu clave (no la de debug).
2. Escribe una descripción de tienda de 4000 caracteres orientada a conversión, con palabras clave naturales.
3. Prepara el set completo de capturas para teléfono en las resoluciones que pide Play.
4. Completa el cuestionario de clasificación de edad de tu juego y anota la etiqueta resultante.
5. Configura un canal de **prueba cerrada** con tres correos de probadores.
6. Documenta el procedimiento de recuperación si se perdiera el keystore (spoiler: usar Play App Signing).

## 📝 Reto verificable

Prepara el paquete y la ficha completos de un juego para subir a **Play Console**: AAB firmado con keystore de release, ficha con todos los campos obligatorios rellenados, clasificación de edad obtenida y el build validado en un canal de prueba interna. Entrega también la checklist de publicación marcada.

**Criterio de aceptación**: el AAB se sube al canal interno sin errores de la consola, la app se instala desde el enlace de prueba y la checklist está completa con todos los ítems obligatorios verificados.

## ⚠️ Errores comunes

| Síntoma / mensaje | Causa y cómo arreglar |
|-------------------|-----------------------|
| "You uploaded an APK / debuggable" | Subiste un APK o build de debug. Exporta AAB con keystore de release. |
| "Version code has already been used" | No incrementaste `versionCode`. Súbelo en el preset antes de exportar. |
| El envío queda "en revisión" días | Normal en Apple. Revisa el estado y responde si piden aclaraciones. |
| La ficha no deja publicar | Falta un campo obligatorio (privacidad, clasificación, capturas). Complétalos. |
| iOS: no puedo subir el build | Falta Mac/Xcode o el certificado de firma. Usa un equipo macOS con la cuenta de desarrollador. |

## ❓ Preguntas frecuentes

**❓ ¿Por qué AAB y no APK?** Google exige el App Bundle para apps nuevas: genera APK optimizados por dispositivo, reduciendo el tamaño de descarga. El APK queda para pruebas laterales.

**❓ ¿Qué pasa si pierdo el keystore?** No podrías actualizar la app con la firma original. Por eso conviene usar **Play App Signing**, donde Google custodia la clave de firma.

**❓ ¿Necesito un Mac para iOS?** Sí. Godot exporta el proyecto, pero archivar y subir a App Store Connect requiere macOS con Xcode.

**❓ ¿Qué es el rollout por fases?** Liberar la versión a un porcentaje de usuarios (p. ej. 10%) para vigilar métricas y errores antes de llegar al 100%.

## 🔗 Referencias

- Godot Docs — Exportar para Android: <https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html>
- Ayuda de Play Console: <https://support.google.com/googleplay/android-developer>
- App Store Connect (ayuda): <https://developer.apple.com/help/app-store-connect/>
- Godot Docs — Exportar para iOS: <https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html>

## ➡️ Siguiente clase

[Clase 209 - Desarrollo para consolas: panorama y devkits](../209-desarrollo-para-consolas-panorama-y-devkits/README.md)
