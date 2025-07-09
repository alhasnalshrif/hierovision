const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:5000/api';

class ApiService {
  private baseURL: string;

  constructor() {
    this.baseURL = API_BASE_URL;
  }

  private async request<T>(
    endpoint: string,
    options: RequestInit = {}
  ): Promise<T> {
    const url = `${this.baseURL}${endpoint}`;
    const token = localStorage.getItem('hierovision_token');

    const config: RequestInit = {
      headers: {
        'Content-Type': 'application/json',
        ...(token && { Authorization: `Bearer ${token}` }),
        ...options.headers,
      },
      ...options,
    };

    try {
      const response = await fetch(url, config);

      if (!response.ok) {
        // Try to get error details from response
        let errorMessage = `HTTP error! status: ${response.status}`;
        try {
          const errorData = await response.json();
          if (errorData.error) {
            errorMessage += ` - ${errorData.error}`;
          } else if (errorData.msg) {
            errorMessage += ` - ${errorData.msg}`;
          } else if (errorData.message) {
            errorMessage += ` - ${errorData.message}`;
          }
          console.error('Server error response:', errorData);
        } catch (e) {
          // If we can't parse JSON, stick with the original message
          console.error('Could not parse error response as JSON');
        }
        throw new Error(errorMessage);
      }

      return await response.json();
    } catch (error) {
      console.error('API request failed:', error);
      throw error;
    }
  }

  // Authentication
  async login(email: string, password: string) {
    return this.request('/auth/login', {
      method: 'POST',
      body: JSON.stringify({ email, password }),
    });
  }

  async signup(name: string, email: string, password: string) {
    return this.request('/auth/register', {
      method: 'POST',
      body: JSON.stringify({ fullName: name, email, password }),
    });
  }

  async logout() {
    return this.request('/auth/logout', {
      method: 'POST',
    });
  }

  // User Profile
  async getUserProfile() {
    return this.request('/user/profile');
  }

  async updateUserProfile(profileData: { fullName?: string; selectedCountry?: string }) {
    return this.request('/user/profile', {
      method: 'PUT',
      body: JSON.stringify(profileData),
    });
  }

  async updateUserAvatar(formData: FormData) {
    const token = localStorage.getItem('hierovision_token');

    return fetch(`${this.baseURL}/user/avatar`, {
      method: 'POST',
      headers: {
        ...(token && { Authorization: `Bearer ${token}` }),
      },
      body: formData,
    }).then(response => response.json());
  }

  async deleteUserAvatar() {
    return this.request('/user/avatar', {
      method: 'DELETE',
    });
  }

  // Landmarks
  async getLandmarks() {
    return this.request('/landmarks');
  }

  async getLandmark(id: string) {
    return this.request(`/landmarks/${id}`);
  }

  // Bookmarks
  async getBookmarks() {
    return this.request('/bookmarks');
  }

  async addBookmark(landmarkId: string) {
    return this.request('/bookmarks', {
      method: 'POST',
      body: JSON.stringify({ landmark_id: landmarkId }),
    });
  }

  async removeBookmark(bookmarkId: string) {
    return this.request(`/bookmarks/${bookmarkId}`, {
      method: 'DELETE',
    });
  }

  // Reviews
  async getReviews(landmarkId: string) {
    return this.request(`/landmarks/${landmarkId}/reviews`);
  }

  async addReview(landmarkId: string, rating: number, comment: string) {
    return this.request(`/landmarks/${landmarkId}/reviews`, {
      method: 'POST',
      body: JSON.stringify({ rating, comment }),
    });
  }

  async updateReview(reviewId: string, rating: number, comment: string) {
    return this.request(`/reviews/${reviewId}`, {
      method: 'PUT',
      body: JSON.stringify({ rating, comment }),
    });
  }

  async deleteReview(reviewId: string) {
    return this.request(`/reviews/${reviewId}`, {
      method: 'DELETE',
    });
  }

  // Bookings
  async createBooking(bookingData: any) {
    return this.request('/bookings', {
      method: 'POST',
      body: JSON.stringify(bookingData),
    });
  }

  async getBookings() {
    return this.request('/bookings');
  }

  async getBooking(id: string) {
    return this.request(`/bookings/${id}`);
  }

  async cancelBooking(id: string) {
    return this.request(`/bookings/${id}/cancel`, {
      method: 'POST',
    });
  }

  // Scans
  async getUserScans() {
    return this.request('/scans/user');
  }

  async getScanById(scanId: string) {
    return this.request(`/scans/${scanId}`);
  }

  async saveScan(scanData: any) {
    return this.request('/scans/save', {
      method: 'POST',
      body: JSON.stringify(scanData),
    });
  }

  async deleteScan(scanId: string) {
    return this.request(`/scans/${scanId}`, {
      method: 'DELETE',
    });
  }

  async getRecentScans(limit: number = 10) {
    return this.request(`/scans/recent?limit=${limit}`);
  }

  // Hieroglyph scanning
  async scanHieroglyph(formData: FormData) {
    const token = localStorage.getItem('hierovision_token');

    return fetch(`${this.baseURL}/predict`, {
      method: 'POST',
      headers: {
        ...(token && { Authorization: `Bearer ${token}` }),
      },
      body: formData,
    }).then(response => response.json());
  }

  // Hieroglyph translation
  async translateHieroglyph(formData: FormData) {
    const token = localStorage.getItem('hierovision_token');

    return fetch(`${this.baseURL}/predict/translate`, {
      method: 'POST',
      headers: {
        ...(token && { Authorization: `Bearer ${token}` }),
      },
      body: formData,
    }).then(response => response.json());
  }

  // Save translation to history
  async saveTranslation(translationData: {
    image_path?: string;
    description: string;
    translation: string;
    confidence: number;
    predicted_class?: number;
  }) {
    return this.request('/scans/save', {
      method: 'POST',
      body: JSON.stringify(translationData),
    });
  }

  // Auth verification
  async verifyAuth() {
    return this.request('/auth/verify');
  }

  // Password management
  async changePassword(currentPassword: string, newPassword: string) {
    return this.request('/auth/change-password', {
      method: 'PUT',
      body: JSON.stringify({ currentPassword, newPassword }),
    });
  }

  async resetPassword(email: string) {
    return this.request('/auth/reset-password', {
      method: 'POST',
      body: JSON.stringify({ email }),
    });
  }

  // English to Hieroglyphs translation
  async translateEnglishToHieroglyphs(englishText: string) {
    return this.request('/translate/english-to-hieroglyphs', {
      method: 'POST',
      body: JSON.stringify({ text: englishText }),
    });
  }
}

export const apiService = new ApiService();
export default apiService;
