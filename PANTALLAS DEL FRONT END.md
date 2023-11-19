# Pantallas de la Aplicación de Seguimiento Médico

## 1) Pantalla de Inicio de Sesión (Login)

Esta pantalla permite a los usuarios ingresar con su nombre de usuario y contraseña.

**Características:**

- **Campo de Nombre de Usuario y Contraseña:**
  - En esta pantalla, los usuarios pueden ingresar su nombre de usuario y contraseña en dos campos de texto. El campo de "Nombre de Usuario" permite al usuario ingresar su nombre de usuario o dirección de correo electrónico.
  - El campo de "Contraseña" permite al usuario ingresar su contraseña. Por razones de seguridad, la contraseña generalmente se muestra como caracteres ocultos (asteriscos o puntos) mientras se escribe.
- **aBotón para Iniciar Sesión:**
  - Un botón grande y prominente con la etiqueta "Iniciar Sesión" permite a los usuarios confirmar sus credenciales y acceder a la aplicación después de ingresar su nombre de usuario y contraseña.
- **Enlace "¿Olvidaste tu Contraseña?":**
  - Este enlace es útil para los usuarios que han olvidado su contraseña. Al hacer clic en este enlace, se redirige al usuario a otra pantalla o formulario donde puede solicitar restablecer su contraseña. Por lo general, se les pedirá que ingresen su dirección de correo electrónico para recibir instrucciones sobre cómo restablecer la contraseña.

**Funcionamiento:**

- Cuando el usuario ingresa sus credenciales en los campos de "Nombre de Usuario" y "Contraseña" y luego hace clic en el botón "Iniciar Sesión", la aplicación valida estas credenciales.
- Si las credenciales son válidas, la aplicación permitirá al usuario acceder a su cuenta y lo redirigirá a la pantalla principal de la aplicación.
- Si las credenciales son inválidas o no coinciden con ningún usuario registrado, la aplicación mostrará un mensaje de error y no permitirá el acceso.
- Si el usuario hace clic en el enlace "¿Olvidaste tu Contraseña?", se le redirigirá a una pantalla de recuperación de contraseña donde podrá solicitar el restablecimiento de su contraseña.

**Consideraciones de Seguridad:**

- Es importante implementar medidas de seguridad en la pantalla de inicio de sesión, como proteger las contraseñas almacenadas utilizando técnicas de almacenamiento seguro y autenticación segura.
- También se deben implementar políticas de bloqueo de cuentas después de varios intentos fallidos de inicio de sesión para proteger contra ataques de fuerza bruta.
- Se debe garantizar que la transmisión de credenciales sea segura utilizando HTTPS para proteger los datos mientras se envían al servidor de autenticación.

## 2) Pantalla de Lista de Pacientes

Esta pantalla muestra un listado de pacientes y permite filtrarlos por nombre y apellido.

**Características:**

- **Barra de Búsqueda:** En la parte superior de la pantalla, hay una barra de búsqueda que permite a los usuarios buscar pacientes por nombre y apellido. Los usuarios pueden ingresar el nombre o el apellido del paciente que desean encontrar en esta barra de búsqueda.
- **Lista de Pacientes:** Justo debajo de la barra de búsqueda, se muestra una lista de pacientes que coinciden con los criterios de búsqueda especificados. Cada elemento de la lista suele incluir información básica del paciente, como su nombre, apellido y otra información relevante.
- **Botón para Agregar un Nuevo Paciente:** En la parte inferior de la pantalla o en una ubicación fácilmente accesible, se encuentra un botón que permite a los usuarios agregar un nuevo paciente a la lista. Al hacer clic en este botón, se redirige al usuario a una pantalla de registro de pacientes donde pueden ingresar los datos del nuevo paciente.

**Funcionamiento:**

- Cuando el usuario ingresa caracteres en la barra de búsqueda, la lista de pacientes se actualiza automáticamente para mostrar solo los pacientes cuyos nombres o apellidos coinciden con la cadena de búsqueda. Esto permite a los usuarios encontrar rápidamente a los pacientes que están buscando.
- Al hacer clic en un elemento de la lista (un paciente en particular), se puede implementar una acción que lleve al usuario a la "Pantalla de Detalle del Paciente" para ver información detallada sobre ese paciente.
- Al hacer clic en el botón "Agregar un Nuevo Paciente", se abre la "Pantalla de Registro de Pacientes", donde el usuario puede ingresar los datos del nuevo paciente, como nombre, apellido, información de contacto, etc.

**Beneficios:**

- La "Pantalla de Lista de Pacientes" proporciona a los usuarios una manera eficiente de buscar y acceder a la información de los pacientes en la aplicación.
- La capacidad de filtrar la lista de pacientes por nombre y apellido facilita la búsqueda y la navegación, especialmente cuando la lista de pacientes es larga.
- El botón "Agregar un Nuevo Paciente" simplifica el proceso de registro de nuevos pacientes en el sistema.
- Este tipo de pantalla es fundamental para la gestión de pacientes en una aplicación de seguimiento médico, ya que permite a los usuarios acceder y actualizar la información de los pacientes de manera efectiva.

## 3) Pantalla de Detalle del Paciente

Esta pantalla muestra información detallada de un paciente seleccionado.

**Características:**

- **Detalles del Paciente:** Esta sección muestra información detallada sobre el paciente seleccionado. Los detalles pueden incluir:
  - Nombre completo del paciente.
  - Número de RUC.
  - Dirección de correo electrónico.
  - Otros detalles relevantes, como fecha de nacimiento, número de identificación, etc.
  - Esta sección permite a los usuarios ver la información completa del paciente.
- **Botón para Editar:** Un botón prominente con la etiqueta "Editar" permite a los usuarios editar la información del paciente. Al hacer clic en este botón, se redirige al usuario a la "Pantalla de Edición de Pacientes" donde pueden realizar cambios en la información del paciente.
- **Opciones para Eliminar el Paciente:** Se proporciona una opción para eliminar al paciente seleccionado. Al hacer clic en esta opción, la aplicación puede mostrar un cuadro de diálogo de confirmación para evitar eliminaciones accidentales.

**Funcionamiento:**

- Cuando un usuario hace clic en un paciente en la "Pantalla de Lista de Pacientes" (o en cualquier otra ubicación donde se accede a los detalles del paciente), se abre la

 "Pantalla de Detalle del Paciente" con la información completa de ese paciente.

- Si el usuario decide editar la información del paciente, puede hacer clic en el botón "Editar", lo que lo llevará a la "Pantalla de Edición de Pacientes".
- La "Pantalla de Detalle del Paciente" también debe manejar la opción de eliminar el paciente. Cuando el usuario elige eliminar al paciente, la aplicación puede mostrar un cuadro de diálogo de confirmación para asegurarse de que el usuario realmente desea realizar esta acción irreversible.

**Beneficios:**

- La "Pantalla de Detalle del Paciente" proporciona a los usuarios la capacidad de ver y revisar la información detallada de un paciente.
- El botón "Editar" permite a los usuarios realizar cambios en la información del paciente de manera sencilla y conveniente.
- La opción de eliminar al paciente asegura que los usuarios puedan gestionar la lista de pacientes y eliminar registros innecesarios.
- Esta pantalla es fundamental para la gestión de pacientes en una aplicación de seguimiento médico, ya que permite a los usuarios ver y modificar la información de los pacientes según sea necesario.

## 4) Pantalla de Reserva de Turno

Esta pantalla permite a los pacientes reservar un turno con un fisioterapeuta en una fecha y hora específicas.

**Características:**

- **Selección de fisioterapeuta (puede estar preseleccionado).**
- **Calendario para elegir la fecha.**
- **Lista de horarios disponibles para el fisioterapeuta seleccionado.**
- **Observaciones y botón para confirmar la reserva.**

## 5) Pantalla de Lista de Reservas

Esta pantalla muestra una lista de las reservas de turno realizadas por el paciente.

**Características:**

- **Selección de Fisioterapeuta:** En esta sección, los pacientes pueden seleccionar al fisioterapeuta con el que desean programar una cita. La selección puede estar preseleccionada si la aplicación ya tiene información sobre el fisioterapeuta del paciente.
- **Calendario para Elegir la Fecha:** Aquí se muestra un calendario que permite a los pacientes seleccionar la fecha en la que desean programar su cita. Los días disponibles suelen estar resaltados o marcados de alguna manera.
- **Lista de Horarios Disponibles:** A continuación del calendario, se muestra una lista de horarios disponibles para el fisioterapeuta seleccionado en la fecha elegida. Los horarios suelen estar ordenados y pueden mostrar la hora de inicio y fin de cada turno disponible.
- **Observaciones:** Se proporciona un campo de texto donde los pacientes pueden ingresar observaciones adicionales o notas relacionadas con su cita. Esto es opcional y puede utilizarse para proporcionar información adicional al fisioterapeuta.
- **Botón para Confirmar la Reserva:** Un botón destacado con la etiqueta "Confirmar Reserva" permite a los pacientes finalizar el proceso de reserva y programar su cita. Al hacer clic en este botón, la información de la cita se envía al servidor y se registra en el sistema.

**Funcionamiento:**

- Cuando un paciente accede a la "Pantalla de Reserva de Turno", puede seleccionar un fisioterapeuta (si no está preseleccionado), elegir una fecha en el calendario y seleccionar un horario disponible de la lista.
- El paciente también puede ingresar observaciones adicionales si es necesario.
- Después de completar todos los campos requeridos, el paciente hace clic en el botón "Confirmar Reserva". En este punto, la aplicación puede realizar una solicitud al servidor para registrar la reserva y, si se confirma con éxito, mostrar un mensaje de confirmación al paciente.

**Beneficios:**

- La "Pantalla de Reserva de Turno" brinda a los pacientes la capacidad de programar sus citas de manera eficiente y conveniente.
- La selección de fisioterapeuta permite a los pacientes elegir a un profesional específico si lo desean.
- El calendario y la lista de horarios disponibles ayudan a los pacientes a encontrar fechas y horarios convenientes para sus citas.
- La opción de ingresar observaciones permite a los pacientes proporcionar información adicional que el fisioterapeuta pueda necesitar.
- Esta pantalla es esencial para la gestión de citas en una aplicación de seguimiento médico y facilita a los pacientes la programación de sus citas.

## 6) Pantalla de Ficha Clínica

Esta pantalla permite registrar y ver las fichas clínicas de los pacientes.

**Características:**

- **Formulario para Registrar una Nueva Ficha Clínica:** Esta sección permite a los usuarios, que generalmente serán fisioterapeutas o profesionales de la salud, registrar una nueva ficha clínica para un paciente. El formulario suele incluir los siguientes campos:
  - Motivo de Consulta: Describe por qué el paciente busca tratamiento.
  - Diagnóstico: Detalla el diagnóstico del paciente.
  - Observación: Espacio para notas adicionales o comentarios sobre el paciente y su tratamiento.
  - Selección de Paciente: Permite al usuario asociar la ficha clínica a un paciente específico.
  - Selección de Fisioterapeuta: Permite al usuario asociar la ficha clínica a un fisioterapeuta específico.
  - Fecha: La fecha se completa automáticamente o se selecciona manualmente.
- **Lista de Fichas Clínicas con Filtros:** A continuación del formulario de registro, se muestra una lista de fichas clínicas registradas en la aplicación. Los usuarios pueden filtrar estas fichas clínicas utilizando varios criterios, como:
  - Fisioterapeuta: Filtra las fichas clínicas por el fisioterapeuta asignado.
  - Paciente: Filtra las fichas clínicas por el paciente relacionado.
  - Fecha Desde y Fecha Hasta: Permite definir un rango de fechas para buscar fichas clínicas.
  - Tipo de Producto (si aplica): Puede ser utilizado para filtrar fichas clínicas por tipo de tratamiento o servicio médico.
- **Detalles de una Ficha Clínica con Opción para Editar la Observación:** Al hacer clic en una ficha clínica específica en la lista, se abre una vista de detalle que muestra toda la información registrada en la ficha clínica. Además, esta vista de detalle debe permitir a los usuarios editar la observación si es necesario. También puede incluir otros detalles como el nombre del paciente, el fisioterapeuta asignado, la fecha, el motivo de consulta y el diagnóstico.

**Funcionamiento:**

- Para registrar una nueva ficha clínica, el usuario completa los campos requeridos en el formulario, selecciona el paciente y el fisioterapeuta correspondientes y hace clic en un botón para guardar la ficha clínica.

 La información se almacena en la base de datos de la aplicación.

- Para buscar fichas clínicas existentes, el usuario puede aplicar filtros utilizando los criterios mencionados anteriormente y ver la lista de fichas clínicas que coinciden con esos filtros.
- Al hacer clic en una ficha clínica en la lista, se muestra una vista de detalle que permite al usuario ver la información completa de la ficha clínica. Si es necesario, el usuario puede editar la observación y guardar los cambios.

**Beneficios:**

- La "Pantalla de Ficha Clínica" es esencial para el registro y seguimiento de la información médica de los pacientes.
- El formulario de registro facilita a los fisioterapeutas o profesionales de la salud la documentación de las fichas clínicas.
- La lista de fichas clínicas con filtros permite una búsqueda eficiente de registros existentes.
- La capacidad de editar la observación proporciona flexibilidad para realizar actualizaciones en la información de la ficha clínica cuando sea necesario.
- Esta pantalla es fundamental para llevar un registro completo y organizado de la atención médica y el historial clínico de los pacientes.
