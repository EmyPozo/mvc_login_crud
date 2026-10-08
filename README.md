<h1 align="center">📦 MVC Login CRUD</h1>

<p align="center">
  Aplicación web con <b>Ruby on Rails</b> que implementa el patrón <b>MVC</b>,
  un <b>CRUD de productos</b> y un sistema de <b>autenticación</b> con contraseñas encriptadas.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Ruby-3.4-CC342D?logo=ruby&logoColor=white" alt="Ruby">
  <img src="https://img.shields.io/badge/Rails-8-D30001?logo=rubyonrails&logoColor=white" alt="Rails">
  <img src="https://img.shields.io/badge/SQLite-003B57?logo=sqlite&logoColor=white" alt="SQLite">
  <img src="https://img.shields.io/badge/Estado-Terminado-brightgreen" alt="Estado">
  <img src="https://img.shields.io/badge/Licencia-MIT-blue" alt="Licencia">
</p>

---

## Índice

- [Descripción](#-descripción)
- [Video de demostración](#-video-de-demostración)
- [Funcionalidades](#-funcionalidades)
- [Arquitectura MVC](#-arquitectura-mvc)
- [Cómo funciona el login](#-cómo-funciona-el-login)
- [Seguridad](#-seguridad)
- [Rutas](#-rutas)
- [Estructura del proyecto](#-estructura-del-proyecto)
- [Instalación y ejecución](#-instalación-y-ejecución)
- [Tecnologías](#-tecnologías)
- [Autora](#-autora)
- [Licencia](#-licencia)

---

## Descripción

Proyecto académico que construye una aplicación básica de gestión de productos.
El objetivo es aplicar el patrón de arquitectura **Modelo – Vista – Controlador (MVC)**,
las operaciones **CRUD** (Crear, Leer, Actualizar, Eliminar) y un sistema de **login**
que protege toda la sección de administración.

Un usuario solo puede acceder al CRUD si inició sesión con su usuario y contraseña.
Cualquier intento de entrar a una URL protegida sin sesión redirige al login.

---


## Video de demostración

▶️ [Ver video (3 min)](PEGA_AQUI_TU_LINK)

El video muestra:
1. El funcionamiento del login (credenciales incorrectas y correctas).
2. Que no se puede acceder a la sección protegida sin iniciar sesión.
3. La contraseña guardada con encriptación (hash bcrypt).

---

## ✨ Funcionalidades

- ✅ Inicio y cierre de sesión con usuario y contraseña
- ✅ Contraseñas encriptadas con **bcrypt**
- ✅ Todas las URLs del CRUD protegidas (redirección automática al login)
- ✅ CRUD completo de productos:
    - **Crear** productos con nombre, descripción, precio y stock
    - **Leer** listado y detalle de cada producto
    - **Actualizar** datos de un producto
    - **Eliminar** con confirmación
- ✅ Validaciones en formularios (nombre obligatorio, precio y stock no negativos)
- ✅ Panel con estadísticas: total de productos, unidades y valor del inventario
- ✅ Etiquetas de colores según el stock (disponible, bajo, agotado)
- ✅ Mensajes de éxito y error
- ✅ Diseño responsivo

---

## Arquitectura MVC

| Capa | Responsabilidad | Archivos |
|------|-----------------|----------|
| **Modelo** | Datos, reglas y validaciones | `app/models/user.rb`, `app/models/product.rb` |
| **Vista** | Lo que ve el usuario (HTML + ERB) | `app/views/sessions/`, `app/views/products/`, `app/views/layouts/` |
| **Controlador** | Recibe la petición, usa el modelo y elige la vista | `app/controllers/sessions_controller.rb`, `app/controllers/products_controller.rb`, `app/controllers/application_controller.rb` |

**Flujo de una petición:**

```
Navegador → Ruta (routes.rb) → Controlador → Modelo → Base de datos
                                    ↓
                               Vista (.erb) → HTML → Navegador
```

---

## Cómo funciona el login

1. El usuario envía su usuario y contraseña desde el formulario (`sessions/new.html.erb`).
2. `SessionsController#create` busca al usuario en la base de datos.
3. `authenticate` encripta la contraseña ingresada y la compara con el hash guardado.
4. Si coincide, se guarda `session[:user_id]` y se redirige al CRUD.
5. Si no, se muestra un mensaje de error.

**Protección de las URLs:**

`ApplicationController` define un filtro que se ejecuta antes de cada acción:

```ruby
before_action :require_login
```

Si no hay sesión activa, redirige a `/login`. Solo las acciones de login
(`SessionsController#new` y `#create`) están exentas con `skip_before_action`.

---

## Seguridad

- **Contraseñas encriptadas:** se usa `has_secure_password` (bcrypt). En la base de datos solo se guarda
  el hash en la columna `password_digest`, nunca la contraseña real. Ejemplo:
  `$2a$12$K8s...`
- **¿Por qué bcrypt y no MD5?** MD5 es muy rápido y vulnerable a ataques con tablas precalculadas.
  bcrypt agrega un *salt* aleatorio y es lento a propósito, lo que lo hace mucho más seguro.
- **`reset_session`** al iniciar sesión, para evitar *session fixation*.
- **Protección CSRF** activada por defecto en Rails.
- **Strong parameters** en el CRUD: solo se aceptan los campos permitidos.
- **Sesión en cookie cifrada y firmada.**

---

## Rutas

| Método | Ruta | Acción | Protegida |
|--------|------|--------|:---------:|
| GET | `/login` | Formulario de login | ❌ |
| POST | `/login` | Iniciar sesión | ❌ |
| DELETE | `/logout` | Cerrar sesión | ✅ |
| GET | `/products` | Listar productos | ✅ |
| GET | `/products/new` | Formulario de creación | ✅ |
| POST | `/products` | Crear producto | ✅ |
| GET | `/products/:id` | Ver producto | ✅ |
| GET | `/products/:id/edit` | Formulario de edición | ✅ |
| PATCH/PUT | `/products/:id` | Actualizar producto | ✅ |
| DELETE | `/products/:id` | Eliminar producto | ✅ |

---

## Estructura del proyecto

```
mvc_login_crud/
├── app/
│   ├── assets/stylesheets/application.css   # Estilos
│   ├── controllers/
│   │   ├── application_controller.rb        # Protección con require_login
│   │   ├── products_controller.rb           # CRUD
│   │   └── sessions_controller.rb           # Login / logout
│   ├── models/
│   │   ├── product.rb                       # Modelo Product + validaciones
│   │   └── user.rb                          # Modelo User + bcrypt
│   └── views/
│       ├── layouts/application.html.erb     # Plantilla general
│       ├── products/                        # Vistas del CRUD
│       └── sessions/new.html.erb            # Formulario de login
├── config/routes.rb                         # Rutas
├── db/
│   ├── migrate/                             # Migraciones
│   └── seeds.rb                             # Usuario inicial
├── docs/                                    # Capturas de pantalla
└── README.md
```

---

## Instalación y ejecución

### Requisitos

- Ruby 3.x (en Windows: [RubyInstaller con DevKit](https://rubyinstaller.org/downloads/))
- Rails
- Git

Verifica con:

```bash
ruby -v
rails -v
git --version
```

### Pasos

```bash
# 1. Clonar el repositorio
git clone https://github.com/EmyPozo/mvc_login_crud.git

# 2. Entrar a la carpeta
cd mvc_login_crud

# 3. Instalar dependencias
bundle install

# 4. Crear la base de datos y las tablas
rails db:migrate

# 5. Crear el usuario de prueba
rails db:seed

# 6. Iniciar el servidor
rails server
```

Abrir en el navegador: **http://localhost:3000**

### Credenciales de prueba

| Usuario | Contraseña |
|---------|------------|
| `admin` | `admin123` |

---

## Tecnologías

- [Ruby](https://www.ruby-lang.org/)
- [Ruby on Rails](https://rubyonrails.org/)
- [SQLite](https://www.sqlite.org/)
- [bcrypt](https://github.com/bcrypt-ruby/bcrypt-ruby)
- HTML, ERB y CSS

---

## Autora

**Emily Pozo**
Estudiante de Ingeniería de Software – Universidad de las Américas (UDLA), Quito, Ecuador

[![GitHub](https://img.shields.io/badge/GitHub-EmyPozo-181717?logo=github)](https://github.com/EmyPozo)

---

## Licencia

Este proyecto está bajo la licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.