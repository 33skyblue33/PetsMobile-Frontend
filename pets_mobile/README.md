# Pets Mobile - Pet Adoption App

This repository contains the source code for a cross-platform mobile application for pet adoption, built with Flutter, and its corresponding backend API built with ASP.NET Core.

## Features

-   **Browse Pets:** View a list of available pets for adoption.
-   **User Authentication:** Secure login, registration, and session management using JWT and refresh tokens.
-   **Role-Based Access Control:** Certain actions (adding, editing, deleting pets) are restricted to users with an "Employee" role.
-   **CRUD Operations:** Authenticated employees can create, update, and delete pet listings.
-   **Image Uploads:** Users can pick a photo from their device's gallery, which is uploaded to the server.
-   **Dynamic Theming:** Supports both Light and Dark mode, respecting the user's system preference by default.
-   **State Management:** Uses the Provider package for efficient and centralized state management.

## Technology Stack

### Frontend (Flutter)
-   **Framework:** Flutter 3+
-   **Language:** Dart
-   **State Management:** `provider`
-   **HTTP Client:** `http`
-   **Secure Storage:** `flutter_secure_storage`
-   **Token Handling:** `jwt_decoder`
-   **Image Handling:** `image_picker`

### Backend (ASP.NET Core)
-   **Framework:** .NET 8 (or compatible)
-   **Language:** C#
-   **API:** RESTful API with ASP.NET Core Web API
-   **Authentication:** JWT Bearer Tokens
-   **Database:** Entity Framework Core (compatible with SQL Server, PostgreSQL, etc.)

## System Architecture (C4 Model)

The architecture is documented using the C4 model to provide different levels of detail about the system's structure.

### Level 1: System Context Diagram

This diagram shows the system in its environment with users and external systems.

```mermaid
graph TD
    subgraph "Pets Mobile Ecosystem"
        user("User
        [Person]")
        employee("Employee
        [Person]")
        system("Pets Mobile App
        [Flutter Mobile Application]")
        backend("Backend API
        [ASP.NET Core Web API]")
    end

    user -- "Views pets, logs in,
    registers" --> system
    employee -- "Manages pet listings (CRUD)" --> system
    system -- "Makes API calls over HTTPS
    [JSON]" --> backend
```

### Level 2: Container Diagram

This diagram zooms into the backend to show its major building blocks or "containers".

```mermaid
graph TD
    subgraph "Backend API"
        webApi("Web API
        [ASP.NET Core Container]")
        database("Database
        [SQL Server]")
    end
    
    flutterApp("Flutter Mobile App
    [External System]")

    flutterApp -- "HTTPS API Requests" --> webApi
    webApi -- "Reads/Writes Data
    [Entity Framework Core]" --> database
```

### Level 3: Component Diagram (Flutter App)

This diagram breaks down the Flutter application into its key components and their responsibilities.

```mermaid
graph TD
    subgraph "Flutter Mobile App"
        direction LR
        subgraph "UI Layer"
            widgets("Widgets
            (Pages, Cards, Forms)")
        end
        
        subgraph "State Management"
            providers("Providers
            (AuthService, BreedProvider,
            ThemeProvider)")
        end

        subgraph "Data Layer"
            services("API Services
            (petService, etc.)")
        end
    end

    widgets -- "Triggers actions & reads state" --> providers
    providers -- "Notifies UI of changes" --> widgets
    providers -- "Calls data logic" --> services
    services -- "Makes HTTP requests" --> externalApi("Backend API")
    externalApi -- "Returns data" --> services
    services -- "Returns data to providers" --> providers
```

## UI Wireframes
<img width="2360" height="1636" alt="image" src="https://github.com/user-attachments/assets/58faa344-dcd9-47a2-a86e-6387a9472629" />

## Setup & Running the Application

Follow these steps to get both the backend and frontend running locally.

### 1. Backend Setup

1.  **Clone the Repository:**
    ```bash
    git clone <your-repository-url>
    cd <repository-folder>/PetsMobile
    ```

2.  **Create `wwwroot` Folder:**
    At the root of the ASP.NET Core project, create an empty folder named `wwwroot`. This is required for storing uploaded images.

3.  **Configure `appsettings.json`:**
    Open `appsettings.json` and configure your database connection string and JWT settings.

    ```json
    {
      "ConnectionStrings": {
        "DefaultConnection": "Server=YOUR_SERVER;Database=PetsMobileDb;Trusted_Connection=True;TrustServerCertificate=True;"
      },
      "Jwt": {
        "Key": "YOUR_SUPER_SECRET_AND_LONG_JWT_KEY_HERE",
        "Issuer": "https://localhost:7123", 
        "Audience": "https://localhost:7123"
      }
    }
    ```

4.  **Apply Database Migrations:**
    Open a terminal in the backend project directory and run the following command.
    ```bash
    dotnet ef database update
    ```

5.  **Run the Backend:**
    Run the project from Visual Studio (F5) or via the command line:
    ```bash
    dotnet run
    ```
    Note the URL the application is running on (e.g., `http://localhost:5215`).

### 2. Frontend Setup

1.  **Navigate to the Frontend Directory:**
    Open a new terminal and navigate to the Flutter project folder.
    ```bash
    cd <repository-folder>/pets_mobile_flutter_app
    ```

2.  **Configure the API URL:**
    Open `lib/api/apiConfig.dart` and change the `baseUrl` to match the IP address and port of your running backend. **Do not use `localhost`** for physical device testing.

    ```dart
    // To find your IP on Windows, run 'ipconfig'.
    // On macOS/Linux, run 'ifconfig' or 'ip addr show'.
    class ApiConfig {
      static const String baseUrl = 'http://YOUR_LAPTOP_IP_ADDRESS:5215/api/v3';
    }
    ```

3.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```

4.  **Configure Native Platforms (for Image Picker):**
    -   **iOS:** Add the required keys for camera/photo library access to `ios/Runner/Info.plist`.
    -   **Android:** No configuration needed for recent package versions.

5.  **Run the Flutter App:**
    Ensure an emulator is running or a physical device is connected.
    ```bash
    flutter run
    ```
