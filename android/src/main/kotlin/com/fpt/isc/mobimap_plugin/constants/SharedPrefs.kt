package com.fpt.isc.mobimap_plugin.constants

import android.content.Context
import android.content.SharedPreferences
import com.google.gson.Gson

class SharedPrefs(context: Context) {


    companion object {
        private var mInstance: SharedPrefs? = null
        private var mSharedPreferences: SharedPreferences? = null

        @JvmStatic
        fun getInstance(context: Context): SharedPrefs {
            if (mInstance == null) {
                mInstance = SharedPrefs(context)
            }
            return mInstance!!
        }

        fun destroy() {
            if (mInstance != null) {
                mInstance = null
            }
        }
    }

    init {
        mSharedPreferences = context
            .getSharedPreferences(
                Constants.PREFS_FILE_NAME,
                Context.MODE_PRIVATE
            )
    }




    /**
     * you can save a object using gson
     *
     * @param key
     * @param data
     * @param <T>
    </T> */
    fun <T> put(key: String?, data: T) {
        val editor = mSharedPreferences!!.edit()
        if (data is String) {
            editor.putString(key, data as String)
        } else if (data is Boolean) {
            editor.putBoolean(key, (data as Boolean))
        } else if (data is Float) {
            editor.putFloat(key, (data as Float))
        } else if (data is Int) {
            editor.putInt(key, (data as Int))
        } else if (data is Long) {
            editor.putLong(key, (data as Long))
        } else {
            editor.putString(key, getGSon().toJson(data))
        }
        editor.apply()
    }

    /**
     * you can get a object form SharedPrefs
     *
     * @param key
     * @param anonymousClass
     * @param <T>
     * @return
    </T> */
    operator fun <T> get(key: String?, anonymousClass: Class<T>): T {
        return when (anonymousClass) {
            String::class.java -> {
                mSharedPreferences!!.getString(key, "") as T
            }
            Boolean::class.java -> {
                mSharedPreferences!!.getBoolean(key, false) as T
            }
            Float::class.java -> {
                mSharedPreferences!!.getFloat(key, 0f) as T
            }
            Int::class.java -> {
                mSharedPreferences!!.getInt(key, 0) as T
            }
            Long::class.java -> {
                mSharedPreferences!!.getLong(key, 0) as T
            }
            else -> {
                getGSon().fromJson(mSharedPreferences!!.getString(key, ""), anonymousClass)
            }
        }
    }

    /**
     * ìf you want to change defaultValue when getOject form SharedPrefs
     *
     * @param key
     * @param anonymousClass
     * @param defaultValue
     * @param <T>
     * @return
    </T> */
    operator fun <T> get(key: String?, anonymousClass: Class<T>, defaultValue: T): T? {
        return if (anonymousClass == String::class.java) {
            mSharedPreferences!!.getString(key, defaultValue as String) as T?
        } else if (anonymousClass == Boolean::class.java) {
            java.lang.Boolean.valueOf(
                mSharedPreferences!!.getBoolean(
                    key,
                    (defaultValue as Boolean)
                )
            ) as T
        } else if (anonymousClass == Float::class.java) {
            java.lang.Float.valueOf(
                mSharedPreferences!!.getFloat(
                    key,
                    (defaultValue as Float)
                )
            ) as T
        } else if (anonymousClass == Int::class.java) {
            Integer.valueOf(
                mSharedPreferences!!.getInt(
                    key,
                    (defaultValue as Int)
                )
            ) as T
        } else if (anonymousClass == Long::class.java) {
            java.lang.Long.valueOf(
                mSharedPreferences!!.getLong(
                    key,
                    (defaultValue as Long)
                )
            ) as T
        } else {
            getGSon()
                .fromJson(mSharedPreferences!!.getString(key, ""), anonymousClass)
        }
    }

    /**
     * @param key removePop follow key
     */
    fun remove(key: String?) {
        mSharedPreferences!!.edit().remove(key).apply()
    }

    /**
     * clear all data
     */
    fun clear() {
        mSharedPreferences!!.edit().clear().apply()
    }

    private fun getGSon(): Gson {
        return UtilsHelper.gson
    }
}