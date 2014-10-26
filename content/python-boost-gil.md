---
categories: ["python", "c++"]
tags: ["python", "c++", "boost", "boost-python"]
date: 2010/02/26 11:00:57
guid: http://pieceofpy.com/?p=357
permalink: http://pieceofpy.com/2010/02/26/boost-python-threads-and-releasing-the-gil/
title: Boost Python, Threads, and Releasing the GIL
---
<p>
After Beazley's talk at PyCon &quot;Understanding the Python GIL&quot; I released I had never done any work that released the GIL, spawned threads, did some work, and then restored the GIL. So I wanted to see if I could so something like that with Boost::Python and Boost::Thread and the type of performance I'd get from it with an empty while loop as the baseline. So I hacked up some quick and dirty C++ code and quick bit of runable Python to test out the resulting module and away I went. Below are the code snippets, links to bitbucket, and the results of the Python runable.

<pre class="brush: cpp">
#include <iostream>
#include <vector>
#include <boost/shared_ptr.hpp>
#include <boost/thread.hpp>
#include <boost/python.hpp>

class ScopedGILRelease {
public:
	inline ScopedGILRelease() { m_thread_state = PyEval_SaveThread(); }
	inline ~ScopedGILRelease() {
        PyEval_RestoreThread(m_thread_state);
        m_thread_state = NULL;
    }
private:
	PyThreadState* m_thread_state;
};

void loop(long count)
{
	while (count != 0) {
		count -= 1;
	}
	return;
}

void nogil(int threads, long count)
{
	if (threads <= 0 || count <= 0)
		return;
	
	ScopedGILRelease release_gil = ScopedGILRelease();
	long thread_count = (long)ceil(count / threads);
	
	std::vector<boost::shared_ptr<boost::thread> > v_threads;
	for (int i=0; i != threads; i++) {
		boost::shared_ptr<boost::thread>
		m_thread = boost::shared_ptr<boost::thread>(
		    new boost::thread(
		        boost::bind(loop,thread_count)
		    )
		);
		v_threads.push_back(m_thread);
	}
	
	for (int i=0; i != v_threads.size(); i++)
		v_threads[i]->join();
	
	return;
}

BOOST_PYTHON_MODULE(nogil)
{
	using namespace boost::python;
	def("nogil", nogil);
}
</pre>
</p>

<p>
Then I used the following Python script to run some quick tests.

<pre class="brush: py">
import time
import nogil

def timer(func):
	def wrapper(*arg):
		t1 = time.time()
		func(*arg)
		t2 = time.time()
		print "%s took %0.3f ms" % (func.func_name, (t2-t1)*1000.0)
	return wrapper

@timer
def loopone():
	count = 5000000
	while count != 0:
		count -= 1

@timer
def looptwo():
	count = 5000000
	nogil.nogil(1,count)

@timer
def loopthree():
	count = 5000000
	nogil.nogil(2,count)

@timer
def loopfour():
	count = 5000000
	nogil.nogil(4,count)
	
@timer
def loopfive():
	count = 5000000
	nogil.nogil(6,count)
		
def main():
	loopone()
	looptwo()
	loopthree()
	loopfour()
	loopfive()
	
if __name__ == '__main__':
	main()
</pre>
</p>

<p>
The results I got were quite interesting and very consistent on my MacBook Pro. I ran the script about 1,000 times and got roughly the same results every time.

<pre class="brush: bash">
loopone took 364.159 ms (pure python)
looptwo took 15.295 ms (c++, no GIL, single thread)
loopthree took 7.763 ms (c++, no GIL, two threads)
loopfour took 8.119 ms (c++, no GIL, four threads)
loopfive took 11.102 ms (c++, no GIL, six threads)
</pre>
</p>

Anyway, that's all really. Nothing profound here, no super insightful ending. Just hey look and stuff is faster and I might use this. All the code for this is available in my bitbucket repo. <a href="http://bitbucket.org/wwitzel3/code/src/tip/nogil/">http://bitbucket.org/wwitzel3/code/src/tip/nogil/</a>

You will require Boost Library including Boost Python and Boost Thread as well as Python libraries and includes to build this. For boost, bjam --with-python --with-thread variant=release toolset=gcc is all I did on my Mac. Then I added the resulting lib's as Framework dependencies in Xcode along with the Python.framework.
