#!/usr/bin/env python3
"""
Test script to verify the HieroVision backend setup.
"""

import requests
import json
import sys

BASE_URL = "http://localhost:5000/api"

def test_health():
    """Test health endpoint"""
    try:
        response = requests.get("http://localhost:5000/health")
        if response.status_code == 200:
            print("✅ Health check passed")
            return True
        else:
            print("❌ Health check failed")
            return False
    except Exception as e:
        print(f"❌ Health check failed: {e}")
        return False

def test_landmarks():
    """Test landmarks endpoint"""
    try:
        response = requests.get(f"{BASE_URL}/landmarks")
        if response.status_code == 200:
            data = response.json()
            landmarks_count = len(data.get('landmarks', []))
            print(f"✅ Landmarks endpoint working ({landmarks_count} landmarks)")
            return True
        else:
            print("❌ Landmarks endpoint failed")
            return False
    except Exception as e:
        print(f"❌ Landmarks endpoint failed: {e}")
        return False

def test_auth_endpoints():
    """Test authentication endpoints (should return errors for invalid data)"""
    try:
        # Test login with invalid credentials
        response = requests.post(f"{BASE_URL}/auth/login", 
                               json={"email": "test@test.com", "password": "invalid"})
        if response.status_code in [400, 401, 404]:
            print("✅ Auth endpoints responding correctly")
            return True
        else:
            print("❌ Auth endpoints not responding as expected")
            return False
    except Exception as e:
        print(f"❌ Auth endpoints failed: {e}")
        return False

def main():
    print("🧪 Testing HieroVision Backend Setup...")
    print("=" * 50)
    
    tests = [
        test_health,
        test_landmarks,
        test_auth_endpoints
    ]
    
    passed = 0
    total = len(tests)
    
    for test in tests:
        if test():
            passed += 1
        print()
    
    print("=" * 50)
    print(f"Tests passed: {passed}/{total}")
    
    if passed == total:
        print("🎉 All tests passed! Backend is ready.")
        sys.exit(0)
    else:
        print("❌ Some tests failed. Check backend setup.")
        sys.exit(1)

if __name__ == "__main__":
    main()
