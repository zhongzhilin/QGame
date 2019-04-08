#include "LuaCTest.h"
#include <stdio.h>

CTest::CTest()
{

}

CTest::~CTest()
{
    
}

char* CTest::GetData()
{
    printf("[CTest::GetData]%s./n", m_szData);
    return m_szData;
}

void CTest::SetData(const char* pData)
{
    sprintf(m_szData, "%s", pData);
}