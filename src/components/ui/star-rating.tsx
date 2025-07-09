import { Star } from "lucide-react";
import { cn } from "@/lib/utils";

interface StarRatingProps {
  rating: number;
  onRatingChange?: (rating: number) => void;
  readonly?: boolean;
  size?: "sm" | "md" | "lg";
  className?: string;
}

export const StarRating = ({ 
  rating, 
  onRatingChange, 
  readonly = false, 
  size = "md",
  className 
}: StarRatingProps) => {
  const sizeClasses = {
    sm: "w-4 h-4",
    md: "w-5 h-5",
    lg: "w-6 h-6"
  };

  const handleClick = (newRating: number) => {
    if (!readonly && onRatingChange) {
      onRatingChange(newRating);
    }
  };

  return (
    <div className={cn("flex items-center space-x-1", className)}>
      {[1, 2, 3, 4, 5].map((star) => (
        <Star
          key={star}
          className={cn(
            sizeClasses[size],
            "transition-colors duration-200",
            star <= rating
              ? "fill-yellow-400 text-yellow-400"
              : "fill-transparent text-gray-300",
            !readonly && "cursor-pointer hover:text-yellow-400"
          )}
          onClick={() => handleClick(star)}
        />
      ))}
    </div>
  );
};
