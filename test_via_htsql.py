"""
Highly inefficient means of testing, written to demo problems with
running HTSQL in Travis.  However, now that it's written, we may
as well keep it.  Even silly tests are better than no tests.
"""

import json
import requests
import unittest

class TestDb(unittest.TestCase):

    def test_columns_present(self):
        response = requests.get("http://127.0.0.1:8080/meta(/table)/:json")
        data = json.loads(response.content)
        self.assertIn("table", data)
        self.assertIn({u'name': u'character_work'}, data["table"])
        self.assertIn({u'name': u'character'}, data["table"])

    def test_data_present(self):
        response = requests.get("http://127.0.0.1:8080/count(character)/:json")
        data = json.loads(response.content)
        n_rows = data['0'][0]
        self.assertTrue(n_rows > 1200)

