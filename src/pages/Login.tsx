
import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { useForm } from "react-hook-form";
import { useAuth } from "@/hooks/useAuth";

const Login = () => {
  const [isLoading, setIsLoading] = useState(false);
  const { login } = useAuth();
  const navigate = useNavigate();

  const form = useForm({
    defaultValues: {
      email: "",
      password: "",
    },
    mode: "onChange"
  });

  const onSubmit = async (values: { email: string; password: string }) => {
    setIsLoading(true);
    
    try {
      await login(values.email, values.password);
      // Redirect to home page after successful login
      navigate('/');
    } catch (error: any) {
      console.error("Login error:", error);
      // Error handling is done in the useAuth hook via toast
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-b from-[#F5E9D3] to-[#E3D2B7] px-4 py-8">
      {/* Decorative background elements */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute top-20 left-10 text-[#B98E57]/20 text-6xl animate-pulse">𓂀</div>
        <div className="absolute top-40 right-20 text-[#B98E57]/20 text-4xl animate-pulse" style={{ animationDelay: '1s' }}>𓇳</div>
        <div className="absolute bottom-40 left-20 text-[#B98E57]/20 text-4xl animate-pulse" style={{ animationDelay: '2s' }}>𓊨</div>
        <div className="absolute bottom-20 right-10 text-[#B98E57]/20 text-6xl animate-pulse" style={{ animationDelay: '1.5s' }}>𓋹</div>
      </div>

      <Card className="w-full max-w-md relative bg-white/30 backdrop-blur-sm border-2 border-[#B98E57]/30 shadow-2xl">
        {/* Decorative header with Egyptian motifs */}
        <div className="absolute -top-8 left-1/2 transform -translate-x-1/2">
          <div className="w-16 h-16 bg-gradient-to-br from-[#B98E57] to-[#5E4022] rounded-full flex items-center justify-center shadow-lg">
            <span className="text-white text-2xl">𓂀</span>
          </div>
        </div>

        <CardHeader className="text-center pt-12 pb-6">
          <CardTitle className="text-3xl font-serif text-[#5E4022] mb-2">
            Welcome Back
          </CardTitle>
          <CardDescription className="text-[#5E4022]/70 font-serif">
            Enter the realm of ancient wisdom
          </CardDescription>
          <div className="flex justify-center space-x-4 mt-4 text-[#B98E57]">
            <span className="text-xl">𓈖</span>
            <span className="text-xl">𓇳</span>
            <span className="text-xl">𓊨</span>
          </div>
        </CardHeader>

        <CardContent>
          <Form {...form}>
            <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
              <FormField
                control={form.control}
                name="email"
                rules={{
                  required: "Email is required",
                  pattern: {
                    value: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i,
                    message: "Please enter a valid email address"
                  }
                }}
                render={({ field }) => (
                  <FormItem>
                    <FormLabel className="text-[#5E4022] font-serif flex items-center space-x-2">
                      <span>📧</span>
                      <span>Email</span>
                    </FormLabel>
                    <FormControl>
                      <Input
                        {...field}
                        type="email"
                        placeholder="Enter your email"
                        className="bg-white/50 border-[#B98E57]/30 focus:border-[#B98E57] focus:ring-[#B98E57]/20"
                        required
                      />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="password"
                rules={{
                  required: "Password is required",
                  minLength: {
                    value: 6,
                    message: "Password must be at least 6 characters long"
                  }
                }}
                render={({ field }) => (
                  <FormItem>
                    <FormLabel className="text-[#5E4022] font-serif flex items-center space-x-2">
                      <span>🗝️</span>
                      <span>Password</span>
                    </FormLabel>
                    <FormControl>
                      <Input
                        {...field}
                        type="password"
                        placeholder="Enter your password"
                        className="bg-white/50 border-[#B98E57]/30 focus:border-[#B98E57] focus:ring-[#B98E57]/20"
                        required
                      />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />

              <Button
                type="submit"
                disabled={isLoading}
                className="w-full bg-gradient-to-r from-[#B98E57] to-[#5E4022] hover:from-[#5E4022] hover:to-[#B98E57] text-white font-serif text-lg py-6 shadow-lg hover:shadow-xl transition-all duration-300"
              >
                {isLoading ? (
                  <div className="flex items-center space-x-2">
                    <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                    <span>Entering...</span>
                  </div>
                ) : (
                  <div className="flex items-center space-x-2">
                    <span>𓊪</span>
                    <span>Enter the Temple</span>
                  </div>
                )}
              </Button>

              <div className="text-center space-y-4">
                <Link to="/forgot-password" className="text-[#B98E57] hover:text-[#5E4022] text-sm font-serif transition-colors">
                  Forgotten the ancient words?
                </Link>

                <div className="border-t border-[#B98E57]/20 pt-4">
                  <p className="text-[#5E4022]/70 text-sm mb-2">New to the realm?</p>
                  <Link to="/signup">
                    <Button variant="outline" className="w-full border-[#B98E57] text-[#B98E57] hover:bg-[#B98E57] hover:text-white font-serif">
                      Begin Your Journey
                    </Button>
                  </Link>
                </div>
              </div>
            </form>
          </Form>
        </CardContent>
      </Card>
    </div>
  );
};

export default Login;
