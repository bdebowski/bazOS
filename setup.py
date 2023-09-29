"""
Creates an 8 MB file named HD0 that is all 0xFF Bytes except for the first 512 Byte block.
The first 512 Byte block is all 0x00 Bytes except for the first 4 Bytes.
The first 4 Bytes are a Big-Endian encoding of the file size (0x00080000).
"""

FILENAME = "HD0"
SIZE = 8*1024*1024


def write_drive_file(filepath, size, block_size=512):
    assert size % block_size == 0, "Drive size must be exact multiple of block size"
    num_blocks = size // block_size
    with open(filepath, 'wb') as fp:
        block_zero_as_string = "{:08x}{:08x}".format(block_size, num_blocks) + "00" * (block_size - 8)
        rest_of_drive = "FF" * (size - block_size)
        fp.write(bytes.fromhex(block_zero_as_string + rest_of_drive))


if __name__ == "__main__":
    write_drive_file(FILENAME, SIZE)
