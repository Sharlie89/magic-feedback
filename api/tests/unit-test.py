import unittest
from app import app

class TestApp(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()

    def test_health(self):
        response = self.app.get('/health')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json, {"status": "healthy"})

    def test_receive_feedback(self):
        response = self.app.post('/feedback', json={"feedback": "Great app!"})
        self.assertEqual(response.status_code, 200)
        self.assertIn("Feedback received", response.json["message"])

if __name__ == "__main__":
    unittest.main()
