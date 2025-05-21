#!/bin/bash

# Colors for better output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting Painel Admin Margem Flutter project setup...${NC}"

# Create the Flutter project
echo -e "${GREEN}Creating Flutter project...${NC}"
flutter create --org br.com.margem painel_admin_margem
cd painel_admin_margem

# Clean up default files
rm -rf test
rm lib/main.dart

# Create directory structure
echo -e "${GREEN}Creating project directory structure...${NC}"

# Create lib folder structure
mkdir -p lib/core/error
mkdir -p lib/core/network
mkdir -p lib/core/utils
mkdir -p lib/core/widgets

mkdir -p lib/data/models/auth
mkdir -p lib/data/models/store
mkdir -p lib/data/models/mobile
mkdir -p lib/data/models/support

mkdir -p lib/data/repositories
mkdir -p lib/data/datasources

mkdir -p lib/domain/entities
mkdir -p lib/domain/repositories
mkdir -p lib/domain/usecases/auth
mkdir -p lib/domain/usecases/store
mkdir -p lib/domain/usecases/mobile
mkdir -p lib/domain/usecases/support

mkdir -p lib/presentation/auth/pages
mkdir -p lib/presentation/auth/controllers

mkdir -p lib/presentation/stores/pages
mkdir -p lib/presentation/stores/widgets
mkdir -p lib/presentation/stores/controllers

mkdir -p lib/presentation/mobile/pages
mkdir -p lib/presentation/mobile/widgets
mkdir -p lib/presentation/mobile/controllers

mkdir -p lib/presentation/support/pages
mkdir -p lib/presentation/support/widgets
mkdir -p lib/presentation/support/controllers

mkdir -p lib/presentation/shared/theme
mkdir -p lib/presentation/shared/navigation

# Create core layer files
echo -e "${GREEN}Creating core layer files...${NC}"
touch lib/core/error/failures.dart
touch lib/core/error/exceptions.dart
touch lib/core/network/network_info.dart
touch lib/core/network/api_client.dart
touch lib/core/utils/input_converter.dart
touch lib/core/widgets/custom_button.dart
touch lib/core/widgets/custom_text_field.dart
touch lib/core/widgets/custom_dropdown.dart
touch lib/core/widgets/custom_switch.dart
touch lib/core/widgets/confirmation_dialog.dart

# Create data layer files
echo -e "${GREEN}Creating data layer files...${NC}"
# Models
touch lib/data/models/auth/user_model.dart
touch lib/data/models/auth/auth_request.dart
touch lib/data/models/store/store_model.dart
touch lib/data/models/store/store_request.dart
touch lib/data/models/mobile/mobile_model.dart
touch lib/data/models/mobile/mobile_request.dart
touch lib/data/models/support/support_model.dart
touch lib/data/models/support/support_request.dart

# Repositories
touch lib/data/repositories/auth_repository.dart
touch lib/data/repositories/store_repository.dart
touch lib/data/repositories/mobile_repository.dart
touch lib/data/repositories/support_repository.dart

# Datasources
touch lib/data/datasources/auth_datasource.dart
touch lib/data/datasources/store_datasource.dart
touch lib/data/datasources/mobile_datasource.dart
touch lib/data/datasources/support_datasource.dart

# Create domain layer files
echo -e "${GREEN}Creating domain layer files...${NC}"
# Entities
touch lib/domain/entities/user.dart
touch lib/domain/entities/store.dart
touch lib/domain/entities/mobile_user.dart
touch lib/domain/entities/support_user.dart

# Repository interfaces
touch lib/domain/repositories/i_auth_repository.dart
touch lib/domain/repositories/i_store_repository.dart
touch lib/domain/repositories/i_mobile_repository.dart
touch lib/domain/repositories/i_support_repository.dart

# Use cases - Auth
touch lib/domain/usecases/auth/login_usecase.dart
touch lib/domain/usecases/auth/logout_usecase.dart

# Use cases - Store
touch lib/domain/usecases/store/get_stores_usecase.dart
touch lib/domain/usecases/store/create_store_usecase.dart
touch lib/domain/usecases/store/update_store_usecase.dart
touch lib/domain/usecases/store/delete_store_usecase.dart

# Use cases - Mobile
touch lib/domain/usecases/mobile/get_mobile_users_usecase.dart
touch lib/domain/usecases/mobile/create_mobile_user_usecase.dart
touch lib/domain/usecases/mobile/update_mobile_user_usecase.dart
touch lib/domain/usecases/mobile/delete_mobile_user_usecase.dart

# Use cases - Support
touch lib/domain/usecases/support/get_support_users_usecase.dart
touch lib/domain/usecases/support/create_support_user_usecase.dart
touch lib/domain/usecases/support/update_support_user_usecase.dart
touch lib/domain/usecases/support/delete_support_user_usecase.dart

# Create presentation layer files
echo -e "${GREEN}Creating presentation layer files...${NC}"
# Auth
touch lib/presentation/auth/pages/login_page.dart
touch lib/presentation/auth/controllers/auth_controller.dart

# Stores
touch lib/presentation/stores/pages/stores_page.dart
touch lib/presentation/stores/pages/store_form_page.dart
touch lib/presentation/stores/pages/store_details_page.dart
touch lib/presentation/stores/widgets/store_list_item.dart
touch lib/presentation/stores/widgets/store_filter.dart
touch lib/presentation/stores/controllers/stores_controller.dart

# Mobile
touch lib/presentation/mobile/pages/mobile_users_page.dart
touch lib/presentation/mobile/pages/mobile_user_form_page.dart
touch lib/presentation/mobile/pages/mobile_user_stores_page.dart
touch lib/presentation/mobile/widgets/mobile_user_list_item.dart
touch lib/presentation/mobile/widgets/store_selector.dart
touch lib/presentation/mobile/controllers/mobile_controller.dart

# Support
touch lib/presentation/support/pages/support_users_page.dart
touch lib/presentation/support/pages/support_user_form_page.dart
touch lib/presentation/support/widgets/support_user_list_item.dart
touch lib/presentation/support/controllers/support_controller.dart

# Shared
touch lib/presentation/shared/theme/app_colors.dart
touch lib/presentation/shared/theme/app_text_styles.dart
touch lib/presentation/shared/theme/app_theme.dart
touch lib/presentation/shared/navigation/app_routes.dart

# Create main.dart
touch lib/main.dart

# Update pubspec.yaml with required dependencies
echo -e "${GREEN}Updating pubspec.yaml with required dependencies...${NC}"

cat > pubspec.yaml << 'EOF'
name: painel_admin_margem
description: Painel Admin Margem - A Flutter application for business management
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.5
  
  # State management
  get: ^4.6.5
  
  # API
  dio: ^5.3.0
  http: ^1.1.0
  
  # Local storage
  shared_preferences: ^2.2.0
  
  # Navigation
  go_router: ^10.0.0
  
  # Utils
  dartz: ^0.10.1
  equatable: ^2.0.5
  intl: ^0.18.1
  flutter_dotenv: ^5.1.0
  
  # UI
  flutter_svg: ^2.0.7
  google_fonts: ^5.1.0
  mask_text_input_formatter: ^2.5.0
  shimmer: ^3.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.2
  build_runner: ^2.4.6
  mockito: ^5.4.2

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
    - .env
EOF

# Create assets directories
mkdir -p assets/images
mkdir -p assets/icons

# Create a sample .env file
echo -e "${GREEN}Creating sample .env file...${NC}"
cat > .env << 'EOF'
API_BASE_URL=https://api.painelmargem.com.br
EOF

# Create a basic analysis_options.yaml
echo -e "${GREEN}Creating analysis_options.yaml...${NC}"
cat > analysis_options.yaml << 'EOF'
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - avoid_print: true
    - avoid_empty_else: true
    - avoid_relative_lib_imports: true
    - avoid_returning_null_for_future: true
    - avoid_slow_async_io: true
    - avoid_types_as_parameter_names: true
    - cancel_subscriptions: true
    - close_sinks: true
    - control_flow_in_finally: true
    - empty_statements: true
    - no_duplicate_case_values: true
    - prefer_const_constructors: true
    - prefer_const_declarations: true
    - prefer_final_fields: true
    - prefer_final_locals: true
    - sized_box_for_whitespace: true
    - unnecessary_await_in_return: true

analyzer:
  errors:
    missing_required_param: error
    missing_return: error
    must_be_immutable: error
    sort_unnamed_constructors_first: ignore
EOF

echo -e "${BLUE}Setup complete! Project structure created successfully.${NC}"
echo -e "${GREEN}Next steps:${NC}"
echo -e "1. cd painel_admin_margem"
echo -e "2. flutter pub get"
echo -e "3. Start implementing the core functionality and UI components"