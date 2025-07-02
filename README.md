# Couple Finances

Shared Finances es una aplicación para gestionar y organizar las finanzas en grupo.
![image](https://github.com/user-attachments/assets/44f84b24-eefd-453b-b222-c958db46d2eb)


## Requisitos

- **Ruby version:** 3.3.1
- **Rails version:** 8.0.2
- **Base de datos:** PostgreSQL

## Instalación

1. Clona el repositorio:

  ```bash
  git clone https://github.com/tu-usuario/couple-finances.git
  cd couple-finances
  ```

2. Instala las dependencias:

  ```bash
  bundle install
  rails tailwindcss:build
  ```

3. Configura las credenciales de development.

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

¡Contribuciones y sugerencias son bienvenidas!
