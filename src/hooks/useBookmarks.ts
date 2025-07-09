import { useState, useEffect, useCallback } from 'react';
import { apiService } from '@/services/api';
import { useAuth } from './useAuth';

export interface Bookmark {
  id: string;
  landmark_id: string;
  user_id: string;
  created_at: string;
}

export const useBookmarks = () => {
  const [bookmarks, setBookmarks] = useState<Bookmark[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const { user } = useAuth();

  const fetchBookmarks = useCallback(async () => {
    if (!user) {
      setBookmarks([]);
      setLoading(false);
      return;
    }

    try {
      setLoading(true);
      const data = await apiService.getBookmarks() as { bookmarks: Bookmark[] };
      setBookmarks(data.bookmarks || []);
      setError(null);
    } catch (err) {
      setError('Failed to fetch bookmarks');
      console.error('Error fetching bookmarks:', err);
    } finally {
      setLoading(false);
    }
  }, [user]);

  const addBookmark = async (landmarkId: string) => {
    if (!user) {
      throw new Error('User must be logged in to bookmark');
    }

    try {
      const newBookmark = await apiService.addBookmark(landmarkId) as { bookmark: Bookmark };
      setBookmarks(prev => [...prev, newBookmark.bookmark]);
      return newBookmark.bookmark;
    } catch (err) {
      console.error('Error adding bookmark:', err);
      throw err;
    }
  };

  const removeBookmark = async (landmarkId: string) => {
    if (!user) {
      throw new Error('User must be logged in to remove bookmark');
    }

    try {
      await apiService.removeBookmark(landmarkId);
      setBookmarks(prev => prev.filter(bookmark => bookmark.landmark_id !== landmarkId));
    } catch (err) {
      console.error('Error removing bookmark:', err);
      throw err;
    }
  };

  const isBookmarked = (landmarkId: string) => {
    return bookmarks.some(bookmark => bookmark.landmark_id === landmarkId);
  };

  const toggleBookmark = async (landmarkId: string) => {
    if (isBookmarked(landmarkId)) {
      await removeBookmark(landmarkId);
    } else {
      await addBookmark(landmarkId);
    }
  };

  useEffect(() => {
    fetchBookmarks();
  }, [fetchBookmarks]);

  return {
    bookmarks,
    loading,
    error,
    addBookmark,
    removeBookmark,
    isBookmarked,
    toggleBookmark,
    refetch: fetchBookmarks
  };
};
