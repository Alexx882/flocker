import unittest
import sys
sys.path.insert(1, './')

# python -m unittest discover -v tests
from processing.clusterer import Clusterer

class TestClusterer(unittest.TestCase):
    clusterer:Clusterer = None

    def setUp(self):
        self.clusterer = Clusterer()

    def test_create_labels_noneInput_noneOutput(self):
        labels = self.clusterer.create_labels(None)
        self.assertEqual(None, labels)

    def test_create_labels_emptyInput_emptyOutput(self):
        labels = self.clusterer.create_labels([])
        self.assertEqual([], labels)

    def test_create_labels_singleInput_singleCluster(self):
        labels = self.clusterer.create_labels([self.location(1,2)])
        self.assertEqual(1, len(labels))

    def test_create_labels_nearInputs_singleCluster(self):
        clusterer = Clusterer(epsilon=10, min_points=2)
        locations = [self.location(1,2), self.location(2,2)]

        labels = clusterer.create_labels(locations)

        self.assertEqual(2, len(labels))
        self.assertEqual(labels[0], labels[1])

    def test_create_labels_nearInputs_twoClusters(self):
        clusterer = Clusterer(epsilon=10, min_points=2)
        locations = [self.location(1,2), self.location(2,2), self.location(20,20)]

        labels = clusterer.create_labels(locations)

        self.assertEqual(3, len(labels))
        self.assertEqual(labels[0], labels[1])
        self.assertNotEqual(labels[0], labels[2])

    # helper methods:
    def location(self, lat, long_) -> dict:
        return {'latitude': lat, 'longitude':long_}

if __name__ == '__main__':
    unittest.main()
