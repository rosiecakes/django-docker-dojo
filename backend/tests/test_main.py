from django import test


#  We define a simple, example test for the test-runner skeleton
class GetPublicViewTest(test.SimpleTestCase):
    def test_home(self):
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)