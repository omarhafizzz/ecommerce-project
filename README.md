# LUXE E-Commerce Store

A full-stack e-commerce application built with **React + Node.js + PostgreSQL**, fully containerized with Docker.

---

## 🧱 Tech Stack

| Layer      | Technology                          |
|------------|-------------------------------------|
| Frontend   | React 18, Vite, React Router v6     |
| Backend    | Node.js, Express, JWT Auth          |
| Database   | PostgreSQL 16 (Docker image)        |
| Container  | Docker + Docker Compose             |
| Web Server | Nginx (serves built React app)      |

---

## 🚀 Quick Start

### Prerequisites
- [Docker](https://docs.docker.com/get-docker/) installed
- [Docker Compose](https://docs.docker.com/compose/install/) installed

### 1. Clone / extract the project
```bash
cd ecommerce
```

### 2. Start all services
```bash
docker-compose up --build
```

This will:
- Pull the official **postgres:16** image
- Build and start the **Node.js backend**
- Build and start the **React frontend** via Nginx
- Run all database migrations and seed data automatically

### 3. Access the app

| Service   | URL                          |
|-----------|------------------------------|
| Frontend  | http://localhost:3000        |
| Backend   | http://localhost:5000/api    |
| Postgres  | localhost:5432               |

---

## 🔑 Default Credentials

### Admin Account
| Field    | Value             |
|----------|-------------------|
| Email    | admin@shop.com    |
| Password | Admin@1234        |

> Register any new account to get a regular customer account.

---

## 📁 Project Structure

```
ecommerce/
├── docker-compose.yml          # Orchestrates all services
│
├── backend/
│   ├── Dockerfile
│   ├── package.json
│   └── src/
│       ├── index.js            # Express app entry point
│       ├── config/
│       │   ├── db.js           # PostgreSQL connection pool
│       │   └── init.sql        # DB schema + seed data
│       ├── middleware/
│       │   └── auth.js         # JWT + admin guard middleware
│       ├── controllers/
│       │   ├── authController.js
│       │   ├── productController.js
│       │   ├── cartController.js
│       │   ├── orderController.js
│       │   ├── categoryController.js
│       │   └── adminController.js
│       └── routes/
│           └── index.js        # All API routes
│
└── frontend/
    ├── Dockerfile
    ├── nginx.conf
    ├── index.html
    ├── vite.config.js
    └── src/
        ├── main.jsx
        ├── App.jsx             # Router + route guards
        ├── index.css           # Global design system
        ├── utils/api.js        # Axios instance + all API calls
        ├── context/
        │   ├── AuthContext.jsx
        │   ├── CartContext.jsx
        │   └── ToastContext.jsx
        ├── components/
        │   ├── Navbar.jsx/.css
        │   ├── Footer.jsx/.css
        │   ├── ProductCard.jsx/.css
        │   └── AdminSidebar.jsx/.css
        └── pages/
            ├── Home.jsx/.css
            ├── Products.jsx/.css
            ├── ProductDetail.jsx/.css
            ├── Cart.jsx/.css
            ├── Checkout.jsx/.css
            ├── Orders.jsx/.css
            ├── Login.jsx
            ├── Register.jsx
            ├── Auth.css
            ├── Profile.jsx/.css
            ├── AdminDashboard.jsx
            ├── AdminProducts.jsx
            ├── AdminOrders.jsx
            └── Admin.css
```

---

## 🗄️ Database Schema

| Table         | Description                              |
|---------------|------------------------------------------|
| `users`       | Customers and admins with JWT auth       |
| `categories`  | Product categories with slugs            |
| `products`    | Products with images array, stock, etc.  |
| `cart_items`  | Persistent cart per user                 |
| `orders`      | Orders with shipping + payment info      |
| `order_items` | Individual items within each order       |
| `reviews`     | Product reviews with ratings             |
| `addresses`   | Saved user addresses                     |

---

## 🌐 API Endpoints

### Auth
```
POST /api/auth/register     - Register new account
POST /api/auth/login        - Login, returns JWT
GET  /api/auth/me           - Get current user (auth)
PUT  /api/auth/profile      - Update profile (auth)
```

### Products
```
GET    /api/products              - List with filters/search/pagination
GET    /api/products/:id          - Product detail
POST   /api/products              - Create product (admin)
PUT    /api/products/:id          - Update product (admin)
DELETE /api/products/:id          - Delete product (admin)
GET    /api/products/:id/reviews  - Get reviews
POST   /api/products/:id/reviews  - Add review (auth)
```

### Cart
```
GET    /api/cart        - Get cart (auth)
POST   /api/cart        - Add item (auth)
PUT    /api/cart/:id    - Update quantity (auth)
DELETE /api/cart/:id    - Remove item (auth)
DELETE /api/cart        - Clear cart (auth)
```

### Orders
```
POST /api/orders        - Place order from cart (auth)
GET  /api/orders        - My orders (auth)
GET  /api/orders/:id    - Order detail (auth)
```

### Admin
```
GET /api/admin/dashboard              - Stats + charts
GET /api/admin/users                  - All users
GET /api/admin/orders                 - All orders
PUT /api/admin/orders/:id/status      - Update order status
```

---

## ⚙️ Environment Variables

The backend reads from environment variables set in `docker-compose.yml`:

| Variable       | Default                                        |
|----------------|------------------------------------------------|
| `DATABASE_URL` | postgresql://ecom_user:ecom_pass@postgres:5432/ecommerce |
| `JWT_SECRET`   | supersecretjwtkey_change_in_production         |
| `PORT`         | 5000                                           |

> ⚠️ **Change `JWT_SECRET`** to a strong random string before deploying to production!

---

## 🛠️ Local Development (without Docker)

### Backend
```bash
cd backend
npm install
# Create a .env file:
echo "DATABASE_URL=postgresql://ecom_user:ecom_pass@localhost:5432/ecommerce" > .env
echo "JWT_SECRET=devjwtsecret" >> .env
echo "PORT=5000" >> .env
npm run dev
```

### Frontend
```bash
cd frontend
npm install
npm run dev     # runs on http://localhost:5173
```

> The Vite dev server proxies `/api` to `http://localhost:5000` automatically.

---

## 🧩 Features

### Customer
- Browse products by category, search, sort, filter
- Product detail with image gallery and reviews
- Persistent shopping cart (saved in database)
- Multi-step checkout (shipping → payment → review)
- Order history with expandable item details
- User profile management

### Admin (`/admin`)
- Revenue dashboard with bar chart
- Top products by sales
- Recent orders table
- Full product CRUD (create, edit, delete)
- Order management with status updates

---

## 🔒 Security Notes

For production deployment:
1. Change `JWT_SECRET` to a long random string
2. Set strong `POSTGRES_PASSWORD` in `docker-compose.yml`
3. Place the app behind HTTPS (e.g. Nginx + Certbot)
4. Remove demo credentials from the login page
