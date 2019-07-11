cmake_minimum_required(VERSION 3.1)
project (TeamTalkToolchain)

if (MSVC)
  set (TTLIBS_ROOT ${CMAKE_CURRENT_LIST_DIR}/build)
else()
  
  if (${CMAKE_SYSTEM_NAME} MATCHES "Android")
    set (TTLIBS_ROOT ${CMAKE_CURRENT_LIST_DIR}/${CMAKE_ANDROID_ARCH_ABI})
  else()
    set (TTLIBS_ROOT ${CMAKE_CURRENT_LIST_DIR})
  endif()

endif()

set (TTLIBS_ROOT ${TTLIBS_ROOT} PARENT_SCOPE)
