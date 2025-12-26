from setuptools import setup, find_packages

setup(
    name="hello-python",
    version="0.1.0",
    package_dir={'': 'src'},
    packages=find_packages(where='src'),
    entry_points={
        'console_scripts': [
            'hello-python=hello_python.main:main',
        ],
    },
)
