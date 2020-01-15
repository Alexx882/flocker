import unittest
import sys
sys.path.insert(1, './')

# python -m unittest discover -v tests
from processing.clusterer import Clusterer

class TestClusterer(unittest.TestCase):
    clusterer:Clusterer = None

    def setUp(self):
        self.clusterer = Clusterer(epsilon=10, min_points=2)

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
        locations = [self.location(1,2), self.location(2,2)]

        labels = self.clusterer.create_labels(locations)

        self.assertEqual(2, len(labels))
        self.assertEqual(labels[0], labels[1])

    def test_create_labels_nearInputs_twoClusters(self):
        locations = [self.location(1,2), self.location(2,2), self.location(20,20)]

        labels = self.clusterer.create_labels(locations)

        self.assertEqual(3, len(labels))
        self.assertEqual(labels[0], labels[1])
        self.assertNotEqual(labels[0], labels[2])

    def test_label_locations_NoneLocations_NoException(self):
        self.clusterer.label_locations(None, [])

    def test_label_locations_NoneLabels_NoException(self):
        self.clusterer.label_locations([], None)

    def test_label_locations_emptyInput_emptyOutput(self):
        locations = []
        self.clusterer.label_locations(locations, [])
        self.assertEqual(0, len(locations))

    def test_label_locations_diffInputLengths_ValueError_1(self):
        with self.assertRaises(ValueError):
            self.clusterer.label_locations([], [1])

    def test_label_locations_diffInputLengths_ValueError_2(self):
        with self.assertRaises(ValueError):
            self.clusterer.label_locations([self.location(1,2)], [])

    def test_label_locations_multInput_correctlyLabeled(self):
        locations = [self.location(1,2), self.location(2,2), self.location(20,20)]
        labels = [17,2,20]

        self.clusterer.label_locations(locations, labels)

        self.assertEqual(3, len(locations))
        self.assertHaveLabelsAsNewKey(locations, labels)


    # helper methods:
    def location(self, lat, long_) -> dict:
        return {'latitude': lat, 'longitude':long_}

    def assertHaveLabelsAsNewKey(self, locations, labels):
        for i in range(len(locations)):
            self.assertEqual(labels[i], locations[i]['cluster_label'])

if __name__ == '__main__':
    unittest.main()
