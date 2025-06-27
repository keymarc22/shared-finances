# Couple Finances

Couple Finances es una aplicación para gestionar y organizar las finanzas en pareja.

## Requisitos

- **Ruby version:** 3.2.2
- **Rails version:** 7.x
- **Base de datos:** PostgreSQL

## Dependencias del sistema

- Node.js >= 16.x
- Yarn >= 1.22.x
- Bundler

## Instalación

1. Clona el repositorio:

  ```bash
  git clone https://github.com/tu-usuario/couple-finances.git
  cd couple-finances
  ```

2. Instala las dependencias:

  ```bash
  bundle install
  yarn install
  ```

3. Configura las variables de entorno en `.env`.

## Creación e inicialización de la base de datos

```bash
rails db:create
rails db:migrate
rails db:seed
```

## Ejecución de la aplicación

```bash
rails server
```

Accede a [http://localhost:3000](http://localhost:3000) en tu navegador.

## Pruebas

Para ejecutar la suite de tests:

```bash
bundle exec rspec
```

## Servicios

- Sidekiq (para colas de trabajo)
- Redis (para caché y Sidekiq)


¡Contribuciones y sugerencias son bienvenidas!
