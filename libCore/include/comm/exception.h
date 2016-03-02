#ifndef EXCEPTION_H
#define EXCEPTION_H

#include <exception>
#include <string>
#include <sstream>

#ifdef WIN32
#define __MY__FILE__ __FILE__
#define __MY__FUNCTION__ __FUNCTION__
#define __MY__LINE__ __LINE__
#else
#define __MY__FILE__ __FILE__
#define __MY__FUNCTION__ __FUNCTION__
#define __MY__LINE__ __LINE__
#endif


#define THROW_WITH_MSG(sReason)			\
	do 									\
	{									\
		throw ExceptionBase(__MY__FILE__,__MY__FUNCTION__,__MY__LINE__,sReason);\
	} while (false)						\

#define THROW_WITH_EXCEPTION(e)			\
	do 									\
	{									\
		throw ExceptionBase(__MY__FILE__,__MY__FUNCTION__,__MY__LINE__,e);\
	} while (false)	

#define THROW_WITH_MSG_EXCEPTION(e)			\
	do 									\
	{									\
		throw ExceptionBase(__MY__FILE__,__MY__FUNCTION__,__MY__LINE__,sReason,e);\
	} while (false)	


/*
// #define DEBUG_THROW(ExClass, args)	\
//   do								\
//   {									\
//   	ExClass e(args);				\
//   	e.Init(__MY__FILE__, __MY__FUNCTION__, __MY__LINE__);\
//   	throw e;						\
//   }									\
//   while (false)	
*/					


class ExceptionBase : public std::exception
{
public:
	virtual ~ExceptionBase() throw()
	{  	
	}

	ExceptionBase(const char* file, const char* func,int line, const char* sReason)
	{
		std::exception ex;
		Init(file, func, line, sReason, ex);
	}
	ExceptionBase(const char* file, const char* func,int line, std::exception& e)
	{
		Init(file, func, line, NULL, e);
	}
	ExceptionBase(const char* file, const char* func,int line, const char* sReason, std::exception& e)
	{
		Init(file, func, line, sReason, e);
	}
	void Init(const char* file, const char* func, int line, const char* sReason, std::exception& prevEx)
	{
		std::stringstream sstr("");
		sstr << file << "(" << line << ")";
		sstr << ":" << func;
		mWhat.append(sstr.str());
		if(sReason)
		{
			mWhat.append(" - ");
			mWhat.append(sReason);
		}
		mWhat.append("\n");
		if (prevEx.what())
			mWhat.append(prevEx.what());
	}
	const char* what() const throw()
	{
		return mWhat.c_str();
	}

private:
	mutable std::string mWhat;
};



#endif //_EXCEPTION_h