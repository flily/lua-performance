#!/bin/sh

############################################################
# find-lua.sh
############################################################


DEBUG_MODE="off"
FIND_ALL="off"

USE_LUA="on"
USE_LUAJIT="off"

PATH_PREFER_LIST="
/usr/local/bin
/usr/bin
/bin
${HOME}/usr/bin
${HOME}/bin
"

debug_print()
{
    if [ "${DEBUG_MODE}" = "on" ]; then
        printf "%s" "$1" >&2
    fi
}

debug_println()
{
    if [ "${DEBUG_MODE}" = "on" ]; then
        printf "%s\\n" "$1" >&2
    fi
}

usage()
{
    echo "usage:"
    echo "    $0 [options..] [path]"
    echo ""
    echo "options:"
    echo "  --help                 show this message"
    echo "  --debug                run in debug mode."
    echo "  --lua51                find lua 5.1"
    echo "  --lua52                find lua 5.2"
    echo "  --lua53                find lua 5.3"
    echo "  --with(out)-lua        find with or without lua official implement, included by default."
    echo "  --with(out)-luajit     find with or without luajit, excluded by deafult."
}

check_lua_version()
{
    LUA_BIN_PATH="$1"
    LUA_VERSION="$2"
    if [ -z "${LUA_VERSION}" ]; then
        LUA_VERSION=""
    fi

    debug_print "checking lua ${LUA_VERSION} binary ${LUA_BIN_PATH}..."

    if [ ! -f "${LUA_BIN_PATH}" ]; then
        debug_println "miss"
        return 1
    fi

    if [ ! -x "${LUA_BIN_PATH}" ]; then
        debug_println "non-executable"
        return 2
    fi

    # VERSION_TAG="$("${LUA_BIN_PATH}" --version 2>&1)"
    RELEASE_TAG="$("${LUA_BIN_PATH}" -v 2>&1 | awk '{print $1}')"
    VERSION_TAG="$("${LUA_BIN_PATH}" -v 2>&1 | awk '{print $2}')"

    debug_print " ${RELEASE_TAG} ${VERSION_TAG} -> "

    if [ "${RELEASE_TAG}" = "LuaJIT" ]; then
        if [ "${USE_LUAJIT}" != "on" ]; then
            debug_println "skip LuaJIT"
            return 3
        fi
        
        if [ -z "${LUA_VERSION}" ] || [ "${LUA_VERSION}" = "5.1" ]; then
            debug_println "ok"
            return 0
        else
            debug_println "error"
            return 4
        fi
    fi

    if [ "${RELEASE_TAG}" = "Lua" ]; then
        if [ "${USE_LUA}" != "on" ]; then
            debug_println "skip Lua"
            return 3
        fi

        if [ -z "${LUA_VERSION}" ]; then
            debug_println "ok"
            return 0
        fi

        VERSION_MAJOR="$(echo "${VERSION_TAG}" | cut -c 1-3 )"
        debug_print "(${VERSION_MAJOR}) "

        if [ "${VERSION_MAJOR}" = "${LUA_VERSION}" ]; then
            debug_println "ok"
            return 0
        else
            debug_println "error"
            return 4
        fi
    fi

    
    
}


find_probable_lua_name()
{
    FIND_PATH="$1"
    PROBABLE_NAMES="$(find "${FIND_PATH}" -name 'lua*' 2>/dev/null)"
    for x in ${PROBABLE_NAMES}; do
        LUA_NAME="$(basename "$x")"
        # debug_println "FIND_PATH=${FIND_PATH}  x=${x}  LUA_NAME=${LUA_NAME}"

        case "${LUA_NAME}" in
            "luac"*)
                # debug_println "[SKIP] Find luac: ${FIND_PATH}/${LUA_NAME}"
                ;;
            "lua"*)
                # debug_println "[INFO] Find lua interpreter: ${FIND_PATH}/${LUA_NAME}"
                echo "${FIND_PATH}/${LUA_NAME}"
                ;;
            *)
                ;;
        esac
    done
}


check_lua_in_path()
{
    ALL_PATH_LIST="$1"
    LUA_VERSION="$2"

    # debug_println "FIND PATH LIST:"
    # debug_println "${ALL_PATH_LIST}"
    # debug_println "==============="

    FOUND_LUA_PATH=""
    for BASE_PATH in ${ALL_PATH_LIST}; do
        debug_println "finding lua ${LUA_VERSION} in ${BASE_PATH}.."

        for LUA_NAME in $(find_probable_lua_name "${BASE_PATH}"); do
            LUA_BIN_PATH="${LUA_NAME}"

            if check_lua_version "${LUA_BIN_PATH}" "${LUA_VERSION}"; then
                if [ -z "${FOUND_LUA_PATH}" ]; then
                    FOUND_LUA_PATH="${LUA_BIN_PATH}"
                fi

                if [ "${FIND_ALL}" = "off" ]; then
                    break
                fi
            fi
        done

        if [ ! -z "${FOUND_LUA_PATH}" ]; then
            if [ "${FIND_ALL}" = "off" ]; then
                break
            fi
        fi
    done

    if [ ! -z "${FOUND_LUA_PATH}" ]; then
        echo "${FOUND_LUA_PATH}"
    fi
}


find_lua()
{
    CHECK_PATH=""
    LUA_VERSION=""

    while [ ! -z "$1" ]; do
        case "$1" in
            "/"*)
                CHECK_PATH="${CHECK_PATH} $1"
                ;;
            "--debug")
                DEBUG_MODE="on"
                ;;
            "--all")
                FIND_ALL="on"
                ;;
            "--lua"*)
                LUA_VERSION="$(echo "$1" | cut -c 6-)"
                ;;
            "--with-lua")
                USE_LUA="on"
                ;;
            "--without-lua")
                USE_LUA="off"
                ;;
            "--with-luajit")
                USE_LUAJIT="on"
                ;;
            "--without-luajit")
                USE_LUAJIT="off"
                ;;
            "--help"|"-h"|"-?")
                usage
                exit
                ;;
        esac
        shift
    done

    # check_path is empty, check for all directory listed.
    if [ -z "${CHECK_PATH}" ]; then
        SYSTEM_LUA_PATH="$(which lua 2>/dev/null)"
        if [ ! -z "${SYSTEM_LUA_PATH}" ]; then
            PATH_PREFER_LIST="${PATH_PREFER_LIST} $(dirname "${SYSTEM_LUA_PATH}")"
        fi

        ALL_PATH_LIST="${PATH_PREFER_LIST} $(echo "$PATH" | tr ':' ' ')"
        check_lua_in_path "${ALL_PATH_LIST}" "${LUA_VERSION}"
        return $?
    fi

    if [ -f "${CHECK_PATH}" ]; then
        if check_lua_version "${CHECK_PATH}" "${LUA_VERSION}"; then
            echo "ok"
            return 0
        else
            echo "error"
            return 1
        fi
    else
        check_lua_in_path "${CHECK_PATH}" "${LUA_VERSION}"
        return $?
    fi
}

find_lua "$@"
