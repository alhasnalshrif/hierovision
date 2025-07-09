import { useState, useEffect } from 'react';
import { apiService } from '@/services/api';
import { useAuth } from './useAuth';

export interface Review {
  id: string;
  landmark_id: string;
  user_id: string;
  user_name: string;
  rating: number;
  comment: string;
  created_at: string;
  updated_at: string;
}

export const useReviews = (landmarkId: string) => {
  const [reviews, setReviews] = useState<Review[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const { user } = useAuth();

  const fetchReviews = async () => {
    if (!landmarkId) return;

    try {
      setLoading(true);
      const data = await apiService.getReviews(landmarkId) as { reviews: Review[] };
      setReviews(data.reviews || []);
      setError(null);
    } catch (err) {
      setError('Failed to fetch reviews');
      console.error('Error fetching reviews:', err);
    } finally {
      setLoading(false);
    }
  };

  const addReview = async (rating: number, comment: string) => {
    if (!user) {
      throw new Error('User must be logged in to add review');
    }

    try {
      const newReview = await apiService.addReview(landmarkId, rating, comment) as { review: Review };
      setReviews(prev => [newReview.review, ...prev]);
      return newReview.review;
    } catch (err) {
      console.error('Error adding review:', err);
      throw err;
    }
  };

  const updateReview = async (reviewId: string, rating: number, comment: string) => {
    if (!user) {
      throw new Error('User must be logged in to update review');
    }

    try {
      const updatedReview = await apiService.updateReview(reviewId, rating, comment) as { review: Review };
      setReviews(prev => prev.map(review => 
        review.id === reviewId ? updatedReview.review : review
      ));
      return updatedReview.review;
    } catch (err) {
      console.error('Error updating review:', err);
      throw err;
    }
  };

  const deleteReview = async (reviewId: string) => {
    if (!user) {
      throw new Error('User must be logged in to delete review');
    }

    try {
      await apiService.deleteReview(reviewId);
      setReviews(prev => prev.filter(review => review.id !== reviewId));
    } catch (err) {
      console.error('Error deleting review:', err);
      throw err;
    }
  };

  const getUserReview = () => {
    if (!user) return null;
    return reviews.find(review => review.user_id === user.id) || null;
  };

  const getAverageRating = () => {
    if (reviews.length === 0) return 0;
    const sum = reviews.reduce((acc, review) => acc + review.rating, 0);
    return sum / reviews.length;
  };

  useEffect(() => {
    fetchReviews();
  }, [landmarkId]);

  return {
    reviews,
    loading,
    error,
    addReview,
    updateReview,
    deleteReview,
    getUserReview,
    getAverageRating,
    refetch: fetchReviews
  };
};
