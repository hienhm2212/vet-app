# VetCare Pro - Veterinary Clinic Management System

A comprehensive Ruby on Rails 8 application for managing veterinary clinic operations including owners, patients, products, appointments, and invoices.

## 🚀 Features

- **Owner Management**: Complete CRUD for pet owners
- **Patient Records**: Pet information and medical history
- **Product Management**: Inventory with barcode generation
- **Appointment Scheduling**: Appointment booking and management
- **Invoice System**: Billing and payment tracking
- **Dashboard**: Real-time statistics and insights
- **Barcode System**: Thermal printer compatible labels
- **Vietnamese Localization**: Full Vietnamese language support

## 🛠 Technology Stack

- **Ruby**: 3.4.5
- **Rails**: 8.0.2
- **Database**: SQLite3 (development), PostgreSQL (production)
- **Frontend**: Bootstrap 5, Chart.js
- **Barcode**: Barby gem with ChunkyPNG
- **Containerization**: Docker & Docker Compose
- **CI/CD**: GitHub Actions
- **Deployment**: Kamal

## 📋 Prerequisites

- Ruby 3.4.5
- Node.js 18+
- SQLite3
- Docker & Docker Compose (optional)

## 🚀 Quick Start

### Local Development

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd vet-app
   ```

2. **Install dependencies**
   ```bash
   bundle install
   npm install
   ```

3. **Setup database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the server**
   ```bash
   rails server
   ```

5. **Visit the application**
   ```
   http://localhost:3000
   ```

### Docker Development

1. **Build and start services**
   ```bash
   docker-compose up --build
   ```

2. **Setup database (first time only)**
   ```bash
   docker-compose exec web rails db:create db:migrate db:seed
   ```

3. **Visit the application**
   ```
   http://localhost:3000
   ```

## 🏗 CI/CD Pipeline

### GitHub Actions Workflow

The application includes a comprehensive CI/CD pipeline with the following stages:

1. **Test & Lint**: Runs tests, RuboCop, and security checks
2. **Security Checks**: Bundle audit and Brakeman security scan
3. **Build**: Creates deployment package
4. **Deploy**: Deploys to staging/production environments

### Pipeline Features

- ✅ **Automated Testing**: Unit and system tests
- ✅ **Code Quality**: RuboCop linting
- ✅ **Security Scanning**: Brakeman and bundle audit
- ✅ **Multi-stage Deployment**: Staging and production
- ✅ **Artifact Management**: Build artifacts and reports
- ✅ **Notifications**: Success/failure notifications

### Triggering the Pipeline

- **Push to `main`**: Triggers full pipeline including production deployment
- **Push to `develop`**: Triggers testing and staging deployment
- **Pull Requests**: Triggers testing and security checks

## 🐳 Docker Deployment

### Production Build

```bash
# Build production image
docker build -t vet-app:latest .

# Run production container
docker run -d \
  -p 3000:3000 \
  -e RAILS_ENV=production \
  -e RAILS_MASTER_KEY=your_master_key \
  -e DATABASE_URL=your_database_url \
  vet-app:latest
```

### Docker Compose Production

```bash
# Start production stack
docker-compose -f docker-compose.prod.yml up -d
```

## 🚀 Kamal Deployment

### Prerequisites

1. **Install Kamal**
   ```bash
   gem install kamal
   ```

2. **Configure deployment**
   ```bash
   # Edit config/deploy.yml with your server details
   # Set up secrets
   kamal setup
   ```

### Deploy Commands

```bash
# Deploy to production
kamal deploy

# Deploy to staging
kamal deploy --config config/deploy.staging.yml

# Rollback deployment
kamal rollback

# View logs
kamal logs

# Access console
kamal app exec bin/rails console
```

## 🔧 Configuration

### Environment Variables

```bash
# Required
RAILS_ENV=production
RAILS_MASTER_KEY=your_master_key
DATABASE_URL=your_database_url

# Optional
REDIS_URL=redis://localhost:6379/0
RAILS_SERVE_STATIC_FILES=true
RAILS_LOG_TO_STDOUT=true
```

### Database Configuration

The application supports both SQLite3 (development) and PostgreSQL (production):

- **Development**: SQLite3 (default)
- **Production**: PostgreSQL (recommended)

## 📊 Monitoring & Health Checks

### Health Check Endpoint

```
GET /health
```

Returns application status including:
- Database connectivity
- Redis status
- Application version
- Environment information

### Monitoring Features

- ✅ **Health Checks**: Automatic health monitoring
- ✅ **Logging**: Structured logging with Rails
- ✅ **Metrics**: Application performance metrics
- ✅ **Alerts**: Failure notifications

## 🔒 Security Features

- **CSRF Protection**: Built-in Rails CSRF protection
- **SQL Injection Prevention**: ActiveRecord parameterized queries
- **XSS Protection**: Rails content security policy
- **Security Scanning**: Automated security checks in CI/CD
- **Dependency Auditing**: Regular security updates

## 📱 API Endpoints

### Health Check
```
GET /health
```

### Owners
```
GET    /owners
POST   /owners
GET    /owners/:id
PUT    /owners/:id
DELETE /owners/:id
```

### Products
```
GET    /products
POST   /products
GET    /products/:id
PUT    /products/:id
DELETE /products/:id
GET    /products/:id/barcode
```

### Appointments
```
GET    /owners/:owner_id/patients/:patient_id/appointments
POST   /owners/:owner_id/patients/:patient_id/appointments
GET    /owners/:owner_id/patients/:patient_id/appointments/:id
PUT    /owners/:owner_id/patients/:patient_id/appointments/:id
DELETE /owners/:owner_id/patients/:patient_id/appointments/:id
```

## 🧪 Testing

### Running Tests

```bash
# Run all tests
rails test

# Run specific test file
rails test test/models/owner_test.rb

# Run with coverage
COVERAGE=true rails test
```

### Test Coverage

The application includes comprehensive test coverage for:
- ✅ **Models**: Validations, associations, scopes
- ✅ **Controllers**: CRUD operations, authorization
- ✅ **Views**: Template rendering, form submissions
- ✅ **System Tests**: End-to-end user workflows

## 📈 Performance Optimization

### Caching

- **Page Caching**: Static page caching
- **Fragment Caching**: Partial view caching
- **SQL Caching**: Query result caching
- **Asset Caching**: Precompiled assets

### Database Optimization

- **Indexes**: Optimized database indexes
- **Query Optimization**: Efficient ActiveRecord queries
- **Connection Pooling**: Database connection management

## 🔄 Backup & Recovery

### Database Backups

```bash
# Manual backup
rails db:backup

# Automated backups (via Kamal)
kamal backup
```

### Backup Features

- ✅ **Automated Backups**: Daily database backups
- ✅ **Retention Policy**: Configurable backup retention
- ✅ **Point-in-time Recovery**: Database restore capabilities
- ✅ **Offsite Storage**: Backup storage in multiple locations

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- ✅ **Code Style**: Follow RuboCop guidelines
- ✅ **Testing**: Write tests for new features
- ✅ **Documentation**: Update documentation as needed
- ✅ **Security**: Follow security best practices

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support and questions:

- 📧 **Email**: support@vetcare-pro.com
- 📖 **Documentation**: [docs.vetcare-pro.com](https://docs.vetcare-pro.com)
- 🐛 **Issues**: [GitHub Issues](https://github.com/your-org/vet-app/issues)

## 🗺 Roadmap

### Upcoming Features

- 🔄 **Mobile App**: React Native mobile application
- 📊 **Advanced Analytics**: Business intelligence dashboard
- 🔔 **Notifications**: SMS and email notifications
- 💳 **Payment Integration**: Online payment processing
- 📱 **PWA Features**: Progressive web app capabilities

### Version History

- **v1.0.0**: Initial release with core features
- **v1.1.0**: Enhanced barcode system and filters
- **v1.2.0**: CI/CD pipeline and deployment automation
- **v1.3.0**: Performance optimizations and monitoring

---

**Built with ❤️ for veterinary clinics worldwide**
