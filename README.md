# HieroVision - Ancient Egyptian Hieroglyph Recognition

🏺 **HieroVision** is a modern web application that uses AI to detect, translate, and analyze ancient Egyptian hieroglyphs. Built with React/TypeScript frontend and Flask Python backend with machine learning capabilities.

## ✨ Features

- **AI-Powered Hieroglyph Recognition** - Upload images and get instant translations
- **Interactive Landmark Explorer** - Discover ancient Egyptian sites and monuments  
- **Personal History** - Track your translation journey
- **Booking System** - Book guided tours to historical sites
- **User Authentication** - Secure user accounts and profiles
- **Responsive Design** - Beautiful UI that works on all devices

## 🚀 Quick Start

### Prerequisites

- **Node.js** (v16 or higher) - [Download here](https://nodejs.org/)
- **Python** (v3.8 or higher) - [Download here](https://python.org/)
- **Git** - [Download here](https://git-scm.com/)

### Option 1: Automated Setup (Recommended)

**Windows:**

```cmd
# Clone the repository
git clone <YOUR_GIT_URL>
cd hierovision-website-main

# Run the automated setup script
start-dev.bat
```

**Linux/macOS:**

```bash
# Clone the repository  
git clone <YOUR_GIT_URL>
cd hierovision-website-main

# Make script executable and run
chmod +x start-dev.sh
./start-dev.sh
```

### Option 2: Manual Setup

**1. Setup Backend (Flask API)**

```bash

**1. Setup Backend (Flask API)**

```bash
cd backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# Linux/macOS:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Place ML models in backend directory:
# - Yolov8m_Best.pt
# - Classification_Model.pt

# Start the backend server
python run.py
```

**2. Setup Frontend (React/Vite)**

```bash
# In a new terminal, from project root
npm install

# Start the frontend development server
npm run dev
```

## 🌐 Access the Application

- **Frontend**: <http://localhost:5173>
- **Backend API**: <http://localhost:5000>
- **API Documentation**: <http://localhost:5000/health>

## 📁 Project Structure

```
hierovision-website-main/
├── backend/                 # Flask API backend
│   ├── app/
│   │   ├── models/         # Database models
│   │   ├── routes/         # API route handlers
│   │   ├── services/       # Business logic
│   │   └── utils/          # Utility functions
│   ├── uploads/            # File upload storage
│   ├── requirements.txt    # Python dependencies
│   └── run.py             # Main entry point
├── src/                    # React frontend
│   ├── components/         # Reusable UI components
│   ├── pages/             # Page components
│   ├── hooks/             # Custom React hooks
│   ├── services/          # API service layer
│   └── lib/               # Utility libraries
├── public/                # Static assets
└── package.json           # Node.js dependencies
```

## 🔧 Configuration

### Environment Variables

**Frontend (.env)**

```env
VITE_API_BASE_URL=http://localhost:5000/api
VITE_APP_NAME=HieroVision
```

**Backend (config.py)**

- Database configuration
- JWT secret keys
- Upload folder paths
- ML model paths

## 🧠 ML Models

HieroVision uses two main ML models:

1. **YOLOv8** (`Yolov8m_Best.pt`) - Object detection for hieroglyphs
2. **Classification Model** (`Classification_Model.pt`) - Hieroglyph classification

*Note: ML models need to be provided separately due to file size constraints.*

## 🚀 Deployment

### Frontend (Vite Build)

```bash
npm run build
npm run preview
```

### Backend (Production)

```bash
cd backend
gunicorn -w 4 -b 0.0.0.0:5000 run:app
```

## 🛠️ Technologies Used

**Frontend:**

- React 18 with TypeScript
- Vite for build tooling
- Tailwind CSS for styling
- shadcn/ui for components
- React Query for data fetching
- React Router for navigation

**Backend:**

- Flask web framework
- SQLAlchemy ORM
- JWT authentication
- PyTorch for ML inference
- OpenCV for image processing
- CORS support

## 📱 Features Overview

### Core Features

- ✅ User authentication (login/signup)
- ✅ Hieroglyph image upload
- ✅ AI-powered hieroglyph detection
- ✅ Translation and analysis
- ✅ Personal scan history
- ✅ Landmark exploration
- ✅ Booking system
- ✅ User profiles

### Pages

- **Home** - Landing page with introduction
- **Upload** - Image upload and analysis
- **Result** - Translation results display  
- **History** - Personal scan history
- **Landmarks** - Explore ancient sites
- **Booking** - Book tours and experiences
- **Profile** - User account management
- **About** - Project information

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For support and questions:

- Check the [Issues](../../issues) page
- Review the backend [README](backend/README.md)
- Consult the setup guide [SETUP_GUIDE.md](SETUP_GUIDE.md)

---

**Made with ❤️ for Ancient Egyptian History Enthusiasts**

- Vite
- TypeScript
- React
- shadcn-ui
- Tailwind CSS

## How can I deploy this project?

Simply open [Lovable](https://lovable.dev/projects/c00b5d18-229d-4c9e-908f-ae2274767b8b) and click on Share -> Publish.

## Can I connect a custom domain to my Lovable project?

Yes, you can!

To connect a domain, navigate to Project > Settings > Domains and click Connect Domain.

Read more here: [Setting up a custom domain](https://docs.lovable.dev/tips-tricks/custom-domain#step-by-step-guide)
