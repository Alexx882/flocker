import json
from decimal import Decimal


def createLocation(id, latitude, longitude, timestamp, username):
    return {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "timestamp": timestamp,
        "username": username
    }


locations = []

user = 'alex'
locs = [
    [1580289600, 46.615814, 14.265907], # S 2 69
    [1580289680, 46.615814, 14.265907], # S 2 69
    [1580289800, 46.615766, 14.265504], # went to toilet

    [1580378400, 46.615626, 14.264844], # next day morning HSA 
    [1580396150, 46.616304, 14.264705], # afternoon course HS4
    [1580396880, 46.615737, 14.265230]  # infolab
]
for i in range(len(locs)):
    locations.append(createLocation(
        f'{user}-{i}', locs[i][1], locs[i][2], locs[i][0], user))


user = 'herry'
locs = [
    [1580289600, 46.615814, 14.265907], # S 2 69
    [1580289680, 46.615814, 14.265907], # S 2 69
    [1580289800, 46.615814, 14.265907], # S 2 69

    [1580378400, 46.615626, 14.264844], # next day morning HSA 
    [1580396150, 46.615737, 14.265230], # infolab
    [1580396880, 46.615737, 14.265230], # infolab
]
for i in range(len(locs)):
    locations.append(createLocation(
        f'{user}-{i}', locs[i][1], locs[i][2], locs[i][0], user))


user = 'anja'
locs = [
    [1580289600, 46.615814, 14.265907], # S 2 69
    [1580289680, 46.615814, 14.265907], # S 2 69
    [1580289800, 46.615814, 14.265907], # S 2 69
    
    # not at aau
    [1580396150, 46.616304, 14.264705], # afternoon course HS4
    [1580396880, 46.616275, 14.264769]  # aula
]
for i in range(len(locs)):
    locations.append(createLocation(
        f'{user}-{i}', locs[i][1], locs[i][2], locs[i][0], user))


with open('db/data.json', 'w') as f:
    f.write(json.dumps(locations))
