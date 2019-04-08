#ifndef _TEST_H  

#define _TEST_H  

class CTest {
public:
    CTest(void);
    ~CTest(void);

    char* GetData();

    void SetData(const char* pData);

private:

    char m_szData[200];

};

#endif  