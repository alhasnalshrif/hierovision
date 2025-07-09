
import { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { apiService } from '@/services/api';
import { toast } from 'sonner';

interface User {
  id: string;
  name: string;
  email: string;
  bio?: string;
}

interface AuthContextType {
  user: User | null;
  login: (email: string, password: string) => Promise<void>;
  signup: (name: string, email: string, password: string) => Promise<void>;
  logout: () => void;
  updateProfile: (userData: Partial<User>) => Promise<void>;
  isLoading: boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider = ({ children }: { children: ReactNode }) => {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const checkAuthStatus = async () => {
      try {
        const savedUser = localStorage.getItem('hierovision_user');
        const token = localStorage.getItem('hierovision_token');
        
        if (savedUser && token) {
          setUser(JSON.parse(savedUser));
        }
      } catch (error) {
        console.error('Error checking auth status:', error);
        localStorage.removeItem('hierovision_user');
        localStorage.removeItem('hierovision_token');
      } finally {
        setIsLoading(false);
      }
    };

    checkAuthStatus();
  }, []);

  const login = async (email: string, password: string) => {
    setIsLoading(true);
    try {
      const response = await apiService.login(email, password) as { 
        success: boolean;
        user: User; 
        token: string; 
      };
      
      if (response.success) {
        localStorage.setItem('hierovision_token', response.token);
        localStorage.setItem('hierovision_user', JSON.stringify(response.user));
        setUser(response.user);
        
        toast.success('Login successful!');
      } else {
        throw new Error('Login failed');
      }
    } catch (error: any) {
      console.error('Login error:', error);
      toast.error(error.message || 'Login failed. Please check your credentials.');
      throw error;
    } finally {
      setIsLoading(false);
    }
  };

  const signup = async (name: string, email: string, password: string) => {
    setIsLoading(true);
    try {
      const response = await apiService.signup(name, email, password) as { 
        success: boolean;
        message: string;
      };
      
      if (response.success) {
        toast.success('Account created successfully! Please log in.');
      } else {
        throw new Error(response.message || 'Signup failed');
      }
    } catch (error: any) {
      console.error('Signup error:', error);
      toast.error(error.message || 'Signup failed. Please try again.');
      throw error;
    } finally {
      setIsLoading(false);
    }
  };

  const logout = async () => {
    try {
      await apiService.logout();
    } catch (error) {
      console.error('Logout error:', error);
    } finally {
      localStorage.removeItem('hierovision_user');
      localStorage.removeItem('hierovision_token');
      setUser(null);
      toast.success('Logged out successfully');
    }
  };

  const updateProfile = async (userData: Partial<User>) => {
    if (!user) return;
    
    try {
      const response = await apiService.updateUserProfile({
        fullName: userData.name,
        selectedCountry: userData.bio, // Using bio field for country for now
      }) as { success: boolean; user: User; message: string };
      
      if (response.success) {
        const updatedUser = { ...user, ...response.user };
        localStorage.setItem('hierovision_user', JSON.stringify(updatedUser));
        setUser(updatedUser);
        toast.success('Profile updated successfully');
      } else {
        throw new Error(response.message || 'Failed to update profile');
      }
    } catch (error: any) {
      console.error('Profile update error:', error);
      toast.error(error.message || 'Failed to update profile');
      throw error;
    }
  };

  const value = {
    user,
    login,
    signup,
    logout,
    updateProfile,
    isLoading
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};
