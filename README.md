# HackerBooks
<h1>Comentarios</h1>
<p>Hay 2 versiones en <b>2 TAGS:</b> "NO_GCD" y "GCD". Se utiliza el framework "vfr" en ambos. Se usa autolayout en ambos</p>
<h2>NO_GCD</h2>
<p>En esta versión no se usa GCD y se descarga el JSON y datos (fotos y PDFs) en la carpeta "Documents" de la "sandbox".</p>
<p>No se consigue actualizar MODELO - VISTA en "ReaderViewController" y se hace una ñapa que está comentada en el código.</p>
<h2>GCD</h2>
<p>Aquí empiezan los problemas de verdad</p>
<p>Se descarga el JSON y las fotos en "Documents" de la "sandbox". Los PDFs se descargan bajo demanda.</p>
<p>Las fotos y los PDFs desde BookViewController se descargan en segundo plano sin problema. Pero cuando estamos visualizando un PDF y seleccionamos una nueva fila es la tabla no hay forma de actualizar la vista desde segundo plano, ni de utilizar un UIActivityViewIndicator, pues genera errores.</p>
<p>No se consigue enviar mensaje al delegado de tabla cuando se selecciona fila de tabla por código.</p>
<h2>Preguntas</h2>
<h5>Tratamiento de Favoritos</h5>
<p>La persistencia de favoritos de hace mediante un array que se mete en NSUserDefaults a través de la clave @"defaults". Lo que se hace es que cada vez que se genera un favorito se le cambia la propiedad isFavorite a YES. A continuación se recorren todos los libros y se añaden a un array los títulos con la propiedad isFavorite = YES. Se añade el array al diccionario de NSUserDefaults.</p>
<h5>Actualizar Favoritos en Tabla</h5>
<p>En este caso podríamos haberlo hecho a través de un delegado o una notificación. Yo lo he hecho a través de notificación, sin userInfo, simplemente para lamar a reloadData. He utilizado la notificación un poco por vagancia y porque es una app pequeñita... :) Pero lo suyo es usar un delegado para no volverse loco luego buscando de dónde vienen y a dónde van las notificaciones.</p>
<p>No es una aberración ni influye en el rendimiento porque la tabla refresca las celdas que se ven y unas poquitas más, y según necesita va pidiendo info.</p>
<p>Otro método disponible para hacer esto sería un "pull to refresh", y valdría la pena cuando sea el usuario el que tenga que actualizar.</p>
<h5>SimplePDFViewController</h5>
<p>Cuando el usuario cambia la selección en la tabla la actualización en el PDF se haría a través de una notificación, dentro de la cual habría un diccionario "userInfo" con el libro seleccionado". En mi caso uso el framework "vfr" y no hay manera humana de actualizar MODELO - VISTA".</p>
<h5>Extras</h5>
<p>Como extra se me ocurre un buscador.</p>
<p>Quizá una versión con la que se pudiera subir y descargar novelas de escritores noveles y/o profesionales. Es decir una app para poder escribir y subir tu novela, y poder leer gratuitamente las que suba el personal.</p>
<p>Monetización por ingreso publicitario.</p>
