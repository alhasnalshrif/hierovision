import { useState, useEffect } from 'react';
import { apiService } from '@/services/api';

export interface Landmark {
  id: string;
  name: string;
  location: string;
  type: string;
  description: string;
  image: string;
  hieroglyphName: string;
  price: number;
  tours: string[];
  averageRating: number;
  reviewCount: number;
  isBookmarked?: boolean;
}

export const useLandmarks = () => {
  const [landmarks, setLandmarks] = useState<Landmark[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchLandmarks = async () => {
    try {
      setLoading(true);
      const data = await apiService.getLandmarks() as { landmarks: Landmark[] };
      setLandmarks(data.landmarks || []);
      setError(null);
    } catch (err) {
      setError('Failed to fetch landmarks');
      console.error('Error fetching landmarks:', err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchLandmarks();
  }, []);

  return { landmarks, loading, error, refetch: fetchLandmarks };
};

export const useLandmark = (id: string) => {
  const [landmark, setLandmark] = useState<Landmark | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchLandmark = async () => {
      if (!id) return;
      
      try {
        setLoading(true);
        const data = await apiService.getLandmark(id) as { landmark: Landmark };
        setLandmark(data.landmark);
        setError(null);
      } catch (err) {
        setError('Failed to fetch landmark');
        console.error('Error fetching landmark:', err);
      } finally {
        setLoading(false);
      }
    };

    fetchLandmark();
  }, [id]);

  return { landmark, loading, error };
};
