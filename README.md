# ClimaCast

Aplicacion de clima desarrollada con Flutter que muestra informacion del tiempo actual, pronostico, calidad del aire, ciudades favoritas y un planificador semanal.

## Como funciona la aplicacion

La app consulta datos de OpenWeatherMap y presenta la informacion en varias vistas:

1. Hoy
- Temperatura actual de la ciudad seleccionada.
- Sensacion termica, humedad y viento.
- Condiciones generales del clima con iconos.

2. Pronostico
- Vista de los siguientes dias.
- Minima y maxima por dia.
- Descripcion del estado del clima.

3. Aire
- Indice AQI actual.
- Semaforo por contaminante (PM2.5, PM10, CO, NO2, O3).
- Recomendaciones automaticas segun el nivel de calidad del aire.
- Indicador de actualizacion: "Actualizado hace X min".

4. Favoritos
- Puedes agregar ciudades a tu lista personalizada.
- Puedes eliminar ciudades (con opcion de deshacer).
- Tus favoritos se guardan localmente y se mantienen al reiniciar la app.

5. Plan
- Planificador semanal con tarjetas por dia.
- Sugerencias de mejor hora para salir, correr y lavar ropa.

## Flujo de uso recomendado

1. Toca el icono de busqueda para cambiar la ciudad principal.
2. Revisa "Hoy" para una vista rapida.
3. Consulta "Pronostico" para planear tus proximos dias.
4. Revisa "Aire" antes de actividad fisica al aire libre.
5. Guarda ciudades en "Favoritos" si viajas o monitoreas varias zonas.
6. Usa "Plan" para organizar actividades segun el clima.

## Recomendaciones para el usuario

1. Verifica tu conexion a internet si no cargan los datos.
2. Usa ciudades bien escritas para mejorar la busqueda.
3. Revisa la seccion Aire en dias con smog o mucho trafico.
4. Si una ciudad no aparece, prueba con el nombre oficial o sin abreviaciones.
5. Actualiza la informacion con el boton de refrescar cuando necesites datos recientes.

## Mensajes comunes

- "No hay conexion a Internet o no se pudo resolver el servidor":
	revisa red movil o WiFi y vuelve a intentar.

- "No se encontro la ciudad":
	corrige el nombre de la ciudad e intenta nuevamente.

## Ejecucion del proyecto

```bash
flutter pub get
flutter run
```

Para generar APK release:

```bash
flutter build apk --release
```
