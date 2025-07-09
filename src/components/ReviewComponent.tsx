import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { StarRating } from "@/components/ui/star-rating";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { useAuth } from "@/hooks/useAuth";
import { Review } from "@/hooks/useReviews";
import { Trash2, Edit3, Save, X } from "lucide-react";

interface ReviewComponentProps {
  reviews: Review[];
  onAddReview: (rating: number, comment: string) => Promise<Review>;
  onUpdateReview: (reviewId: string, rating: number, comment: string) => Promise<Review>;
  onDeleteReview: (reviewId: string) => Promise<void>;
  userReview?: Review | null;
  loading?: boolean;
}

export const ReviewComponent = ({
  reviews,
  onAddReview,
  onUpdateReview,
  onDeleteReview,
  userReview,
  loading = false
}: ReviewComponentProps) => {
  const { user } = useAuth();
  const [newRating, setNewRating] = useState(5);
  const [newComment, setNewComment] = useState("");
  const [editingReview, setEditingReview] = useState<string | null>(null);
  const [editRating, setEditRating] = useState(5);
  const [editComment, setEditComment] = useState("");
  const [submitting, setSubmitting] = useState(false);

  const handleSubmitReview = async () => {
    if (!user || !newComment.trim()) return;

    try {
      setSubmitting(true);
      await onAddReview(newRating, newComment);
      setNewRating(5);
      setNewComment("");
    } catch (error) {
      console.error('Error submitting review:', error);
    } finally {
      setSubmitting(false);
    }
  };

  const handleEditReview = (review: Review) => {
    setEditingReview(review.id);
    setEditRating(review.rating);
    setEditComment(review.comment);
  };

  const handleSaveEdit = async () => {
    if (!editingReview || !editComment.trim()) return;

    try {
      setSubmitting(true);
      await onUpdateReview(editingReview, editRating, editComment);
      setEditingReview(null);
    } catch (error) {
      console.error('Error updating review:', error);
    } finally {
      setSubmitting(false);
    }
  };

  const handleCancelEdit = () => {
    setEditingReview(null);
    setEditRating(5);
    setEditComment("");
  };

  const handleDeleteReview = async (reviewId: string) => {
    if (window.confirm('Are you sure you want to delete this review?')) {
      try {
        await onDeleteReview(reviewId);
      } catch (error) {
        console.error('Error deleting review:', error);
      }
    }
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    });
  };

  const getInitials = (name: string) => {
    return name.split(' ').map(word => word[0]).join('').toUpperCase();
  };

  return (
    <div className="space-y-6">
      <div>
        <h3 className="text-2xl font-serif font-bold text-[#5E4022] mb-4">
          Reviews & Ratings
        </h3>
        
        {/* Average Rating Display */}
        {reviews.length > 0 && (
          <div className="flex items-center space-x-4 mb-6 p-4 bg-white/20 rounded-lg border border-[#B98E57]/20">
            <div className="text-center">
              <div className="text-3xl font-bold text-[#5E4022]">
                {(reviews.reduce((acc, review) => acc + review.rating, 0) / reviews.length).toFixed(1)}
              </div>
              <StarRating 
                rating={reviews.reduce((acc, review) => acc + review.rating, 0) / reviews.length} 
                readonly 
              />
            </div>
            <div className="text-[#5E4022]/70">
              Based on {reviews.length} review{reviews.length !== 1 ? 's' : ''}
            </div>
          </div>
        )}
      </div>

      {/* Add Review Form - Only if user is logged in and hasn't reviewed yet */}
      {user && !userReview && (
        <Card className="bg-white/20 border-[#B98E57]/20">
          <CardHeader>
            <h4 className="text-lg font-serif font-bold text-[#5E4022]">
              Share Your Experience
            </h4>
          </CardHeader>
          <CardContent className="space-y-4">
            <div>
              <label className="block text-[#5E4022] font-serif mb-2">Rating</label>
              <StarRating 
                rating={newRating} 
                onRatingChange={setNewRating} 
                size="lg"
              />
            </div>
            <div>
              <label className="block text-[#5E4022] font-serif mb-2">Comment</label>
              <Textarea
                placeholder="Tell others about your experience..."
                value={newComment}
                onChange={(e) => setNewComment(e.target.value)}
                className="bg-white/50 border-[#B98E57]/30 focus:border-[#B98E57] min-h-[100px]"
              />
            </div>
            <Button
              onClick={handleSubmitReview}
              disabled={!newComment.trim() || submitting}
              className="bg-gradient-to-r from-[#B98E57] to-[#5E4022] text-white font-serif"
            >
              {submitting ? 'Submitting...' : 'Submit Review'}
            </Button>
          </CardContent>
        </Card>
      )}

      {/* Reviews List */}
      <div className="space-y-4">
        {loading ? (
          <div className="text-center py-8 text-[#5E4022]/70">
            Loading reviews...
          </div>
        ) : reviews.length === 0 ? (
          <div className="text-center py-8 text-[#5E4022]/70">
            No reviews yet. Be the first to share your experience!
          </div>
        ) : (
          reviews.map((review) => (
            <Card key={review.id} className="bg-white/20 border-[#B98E57]/20">
              <CardContent className="p-6">
                <div className="flex items-start justify-between mb-4">
                  <div className="flex items-center space-x-3">
                    <Avatar>
                      <AvatarFallback className="bg-[#B98E57] text-white">
                        {getInitials(review.user_name)}
                      </AvatarFallback>
                    </Avatar>
                    <div>
                      <div className="font-serif font-bold text-[#5E4022]">
                        {review.user_name}
                      </div>
                      <div className="text-sm text-[#5E4022]/70">
                        {formatDate(review.created_at)}
                      </div>
                    </div>
                  </div>
                  
                  {user && user.id === review.user_id && (
                    <div className="flex space-x-2">
                      <Button
                        variant="ghost"
                        size="sm"
                        onClick={() => handleEditReview(review)}
                        className="text-[#5E4022] hover:bg-[#B98E57]/10"
                      >
                        <Edit3 className="w-4 h-4" />
                      </Button>
                      <Button
                        variant="ghost"
                        size="sm"
                        onClick={() => handleDeleteReview(review.id)}
                        className="text-red-600 hover:bg-red-50"
                      >
                        <Trash2 className="w-4 h-4" />
                      </Button>
                    </div>
                  )}
                </div>

                {editingReview === review.id ? (
                  <div className="space-y-4">
                    <StarRating 
                      rating={editRating} 
                      onRatingChange={setEditRating} 
                    />
                    <Textarea
                      value={editComment}
                      onChange={(e) => setEditComment(e.target.value)}
                      className="bg-white/50 border-[#B98E57]/30 focus:border-[#B98E57]"
                    />
                    <div className="flex space-x-2">
                      <Button
                        onClick={handleSaveEdit}
                        disabled={!editComment.trim() || submitting}
                        size="sm"
                        className="bg-[#B98E57] text-white"
                      >
                        <Save className="w-4 h-4 mr-2" />
                        {submitting ? 'Saving...' : 'Save'}
                      </Button>
                      <Button
                        onClick={handleCancelEdit}
                        variant="outline"
                        size="sm"
                        className="border-[#5E4022] text-[#5E4022]"
                      >
                        <X className="w-4 h-4 mr-2" />
                        Cancel
                      </Button>
                    </div>
                  </div>
                ) : (
                  <>
                    <StarRating rating={review.rating} readonly className="mb-3" />
                    <p className="text-[#5E4022] leading-relaxed">{review.comment}</p>
                  </>
                )}
              </CardContent>
            </Card>
          ))
        )}
      </div>
    </div>
  );
};
